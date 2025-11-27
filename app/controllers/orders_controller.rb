class CheckoutController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_cart_not_empty

  def show
    @cart = session[:cart] || {}
    @cart_items = Product.where(id: @cart.keys).map do |product|
      { product: product, quantity: @cart[product.id.to_s] }
    end

    @subtotal = @cart_items.sum { |item| item[:product].current_price * item[:quantity] }

    # Use customer's saved address if available, otherwise they'll need to fill it in
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
      # Clear the cart
      session[:cart] = {}
      redirect_to order_confirmation_path(@order), notice: 'Order placed successfully!'
    else
      @cart_items = Product.where(id: @cart.keys).map do |product|
        { product: product, quantity: @cart[product.id.to_s] }
      end
      @subtotal = @cart_items.sum { |item| item[:product].current_price * item[:quantity] }
      @customer = current_customer
      flash.now[:alert] = 'There was an error processing your order. Please check the form.'
      render :show
    end
  end

  private

  def ensure_cart_not_empty
    if session[:cart].blank? || session[:cart].empty?
      redirect_to cart_path, alert: 'Your cart is empty!'
    end
  end
end