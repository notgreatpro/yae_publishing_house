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
  end

  def create
    @cart = session[:cart] || {}
    
    # Get address from params or use customer's saved address
    address_params = if params[:use_saved_address] == '1' && current_customer.has_complete_address?
      {
        address_line1: current_customer.address_line1,
        address_line2: current_customer.address_line2,
        city: current_customer.city,
        postal_code: current_customer.postal_code,
        province_id: current_customer.province_id
      }
    else
      {
        address_line1: params[:address_line1],
        address_line2: params[:address_line2],
        city: params[:city],
        postal_code: params[:postal_code],
        province_id: params[:province_id]
      }
    end

    # Create order
    @order = current_customer.orders.build(
      status: 'pending',
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

    # Calculate totals
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
            customer_email: current_customer.email
          }
        })

        # Mark order as paid
        @order.mark_as_paid!(payment_intent.id, payment_intent.customer)
        
        # Clear the cart
        session[:cart] = {}
        
        redirect_to order_confirmation_path(@order), notice: 'Order placed successfully! Payment confirmed.'
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