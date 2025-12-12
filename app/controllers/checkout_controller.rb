class CheckoutController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_cart_not_empty

  def show
    @cart = session[:cart] || {}
    @cart_items = Product.where(id: @cart.keys).map do |product|
      { product: product, quantity: @cart[product.id.to_s] }
    end

    @subtotal = @cart_items.sum { |item| item[:product].current_price * item[:quantity] }
    @customer = current_customer
    
    # Load countries and provinces for the form
    @countries = Country.active.order(:name)
    @provinces = Province.order(:name)
    
    # Handle coupon from session
    @coupon = nil
    @discount = 0
    
    if session[:coupon_code].present?
      @coupon = Coupon.find_by(code: session[:coupon_code])
      
      if @coupon
        validation = @coupon.valid_for_use?(@subtotal)
        
        if validation == true
          @discount = @coupon.calculate_discount(@subtotal)
        else
          session.delete(:coupon_code)
          flash.now[:alert] = "Coupon removed: #{validation.join(', ')}"
          @coupon = nil
        end
      else
        session.delete(:coupon_code)
      end
    end
    
    @subtotal_after_discount = @subtotal - @discount
  end

  def create
    @cart = session[:cart] || {}
    
    # Calculate subtotal and apply coupon
    subtotal = 0
    @cart.each do |product_id, quantity|
      product = Product.find(product_id)
      subtotal += product.current_price * quantity
    end
    
    # Apply coupon discount
    discount = 0
    coupon = nil
    
    if session[:coupon_code].present?
      coupon = Coupon.find_by(code: session[:coupon_code])
      
      if coupon && coupon.valid_for_use?(subtotal) == true
        discount = coupon.calculate_discount(subtotal)
      else
        session.delete(:coupon_code)
      end
    end
    
    # Determine if this is a Canadian or international order
    is_canada = params[:is_canada] == '1' || params[:is_canada] == true
    
    # Get address from params or use customer's saved address
    address_params = if params[:use_saved_address] == '1' && current_customer.has_complete_address?
      {
        address_line1: current_customer.address_line1,
        address_line2: current_customer.address_line2,
        city: current_customer.city,
        postal_code: current_customer.postal_code,
        province_id: current_customer.province_id,
        country_id: current_customer.country_id,
        is_canada: current_customer.is_canada
      }
    else
      base_params = {
        address_line1: params[:address_line1],
        address_line2: params[:address_line2],
        city: params[:city],
        postal_code: params[:postal_code],
        is_canada: is_canada
      }
      
      if is_canada
        base_params[:province_id] = params[:province_id]
        base_params[:country_id] = Country.find_by(code: 'CA')&.id
      else
        base_params[:country_id] = params[:country_id]
        base_params[:province_id] = nil
      end
      
      base_params
    end

    # Create order with discount information
    @order = current_customer.orders.build(
      status: 'pending',
      discount_amount: discount,
      coupon_code: coupon&.code,
      **address_params
    )

    # Create order items
    @cart.each do |product_id, quantity|
      product = Product.find(product_id)
      @order.order_items.build(
        product: product,
        quantity: quantity,
        price_at_purchase: product.current_price
      )
    end

    # Calculate totals (this will include the discount and appropriate taxes)
    @order.calculate_totals

    if @order.save
      # Process Stripe payment
      begin
        payment_intent = Stripe::PaymentIntent.create({
          amount: (@order.total_amount * 100).to_i, # Stripe uses cents
          currency: 'cad',
          payment_method: params[:stripe_payment_method_id],
          customer: get_or_create_stripe_customer,
          confirm: true,
          automatic_payment_methods: {
            enabled: true,
            allow_redirects: 'never'
          },
          metadata: {
            order_id: @order.id,
            customer_email: current_customer.email,
            coupon_code: coupon&.code,
            shipping_country: @order.country&.name || 'Canada'
          }
        })

        # Mark order as paid
        @order.mark_as_paid!(payment_intent.id, payment_intent.customer)
        
        # Increment coupon usage if coupon was used
        coupon&.increment_usage!
        
        # Clear the cart and coupon from session
        session[:cart] = {}
        session.delete(:coupon_code)
        
        redirect_to confirmation_order_path(@order), notice: 'Order placed successfully! Payment confirmed.'
      rescue Stripe::CardError => e
        # Card was declined
        @order.destroy
        flash[:alert] = "Payment failed: #{e.message}"
        redirect_to checkout_path
      rescue Stripe::StripeError => e
        # Other Stripe error
        @order.destroy
        flash[:alert] = "Payment error: #{e.message}"
        redirect_to checkout_path
      end
    else
      # Reload data for re-rendering the form
      @cart_items = Product.where(id: @cart.keys).map do |product|
        { product: product, quantity: @cart[product.id.to_s] }
      end
      @subtotal = @cart_items.sum { |item| item[:product].current_price * item[:quantity] }
      @customer = current_customer
      @countries = Country.active.order(:name)
      @provinces = Province.order(:name)
      
      flash.now[:alert] = 'There was an error processing your order. Please check the form.'
      render :show
    end
  rescue StandardError => e
    Rails.logger.error "Checkout error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    
    flash[:alert] = "An error occurred: #{e.message}"
    redirect_to checkout_path
  end

  private

  def ensure_cart_not_empty
    if session[:cart].blank? || session[:cart].empty?
      redirect_to cart_path, alert: 'Your cart is empty!'
    end
  end

  def get_or_create_stripe_customer
    if current_customer.stripe_customer_id.present?
      current_customer.stripe_customer_id
    else
      stripe_customer = Stripe::Customer.create({
        email: current_customer.email,
        name: current_customer.full_name,
        metadata: {
          customer_id: current_customer.id
        }
      })
      
      current_customer.update(stripe_customer_id: stripe_customer.id)
      stripe_customer.id
    end
  end
end