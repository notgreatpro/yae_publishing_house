# app/controllers/cart_controller.rb
class CartController < ApplicationController
  before_action :initialize_cart
  
  # GET /cart
  def show
    @cart_items = []
    @subtotal = 0
    
    # Load product details for items in cart
    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        item_total = product.current_price * quantity
        @cart_items << {
          product: product,
          quantity: quantity,
          item_total: item_total
        }
        @subtotal += item_total
      end
    end
    
    # Handle coupon
    @coupon = nil
    @discount = 0
    
    if session[:coupon_code].present?
      @coupon = Coupon.find_by(code: session[:coupon_code])
      
      if @coupon
        validation = @coupon.valid_for_use?(@subtotal)
        
        if validation == true
          @discount = @coupon.calculate_discount(@subtotal)
        else
          # Coupon is no longer valid, remove it
          session.delete(:coupon_code)
          flash.now[:alert] = "Coupon removed: #{validation.join(', ')}"
          @coupon = nil
        end
      else
        # Coupon doesn't exist, remove from session
        session.delete(:coupon_code)
      end
    end
    
    @total = @subtotal - @discount
  end
  
  # POST /cart/add
  def add
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1
    
    # Add to cart or update quantity
    if @cart[product.id.to_s]
      @cart[product.id.to_s] += quantity
    else
      @cart[product.id.to_s] = quantity
    end
    
    session[:cart] = @cart
    
    redirect_to cart_path, notice: "\"#{product.title}\" added to cart!"
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Product not found"
  end
  
  # POST /cart/apply_coupon
  def apply_coupon
    coupon_code = params[:coupon_code].to_s.strip.upcase
    
    if coupon_code.blank?
      redirect_to cart_path, alert: "Please enter a coupon code"
      return
    end
    
    coupon = Coupon.find_by(code: coupon_code)
    
    if coupon.nil?
      redirect_to cart_path, alert: "Invalid coupon code"
      return
    end
    
    # Calculate current cart total and items
    cart_total = calculate_cart_subtotal
    cart_items = get_cart_items
    
    validation = coupon.valid_for_use?(cart_total, current_customer, cart_items)
    
    if validation == true
      session[:coupon_code] = coupon.code
      discount = coupon.calculate_discount(cart_total)
      redirect_to cart_path, notice: "Coupon applied! You saved #{helpers.number_to_currency(discount)}"
    else
      redirect_to cart_path, alert: validation.join(', ')
    end
  end
  
  # DELETE /cart/remove_coupon
  def remove_coupon
    session.delete(:coupon_code)
    redirect_to cart_path, notice: "Coupon removed"
  end
  
  # PATCH /cart/update/:product_id
  def update
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
    
    if quantity > 0
      @cart[product_id] = quantity
      message = "Quantity updated"
    else
      @cart.delete(product_id)
      message = "Item removed from cart"
    end
    
    session[:cart] = @cart
    
    redirect_to cart_path, notice: message
  end
  
  # DELETE /cart/remove/:product_id
  def remove
    product_id = params[:product_id]
    product = Product.find_by(id: product_id)
    
    @cart.delete(product_id)
    session[:cart] = @cart
    
    redirect_to cart_path, notice: "\"#{product&.title}\" removed from cart"
  end
  
  # DELETE /cart/clear
  def clear
    session[:cart] = {}
    session.delete(:coupon_code)
    redirect_to cart_path, notice: "Cart cleared"
  end
  
  private
  
  def initialize_cart
    @cart = session[:cart] ||= {}
  end
  
  def calculate_cart_subtotal
    subtotal = 0
    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      subtotal += product.current_price * quantity if product
    end
    subtotal
  end
  
  def get_cart_items
    items = []
    @cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        items << {
          product: product,
          quantity: quantity,
          item_total: product.current_price * quantity
        }
      end
    end
    items
  end
end