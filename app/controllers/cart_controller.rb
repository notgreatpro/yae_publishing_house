# app/controllers/cart_controller.rb
# Feature 3.1.1 & 3.1.2 - Shopping Cart (8% total)
class CartController < ApplicationController
  before_action :initialize_cart
  
  # GET /cart
  def show
    @cart_items = []
    @total = 0
    
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
        @total += item_total
      end
    end
  end
  
  # POST /cart/add
  # Feature 3.1.1 - Add products to cart (4%)
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
  
  # PATCH /cart/update/:product_id
  # Feature 3.1.2 - Edit quantity (4%)
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
  # Feature 3.1.2 - Remove items (4%)
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
    redirect_to cart_path, notice: "Cart cleared"
  end
  
  private
  
  def initialize_cart
    @cart = session[:cart] ||= {}
  end
end