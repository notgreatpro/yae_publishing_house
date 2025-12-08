class WishlistsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @wishlist_items = current_customer.wishlists.includes(product: [:cover_image_attachment, :authors]).order(created_at: :desc)
  end

  def create
    @product = Product.find(params[:product_id])
    @wishlist = current_customer.wishlists.build(product: @product)

    if @wishlist.save
      respond_to do |format|
        format.html { redirect_to request.referer || product_path(@product), notice: 'Added to wishlist!' }
        format.json { render json: { success: true, message: 'Added to wishlist!' } }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer || product_path(@product), alert: 'Could not add to wishlist.' }
        format.json { render json: { success: false, message: 'Already in wishlist' }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @wishlist = current_customer.wishlists.find(params[:id])
    @product = @wishlist.product
    @wishlist.destroy

    respond_to do |format|
      format.html { redirect_to request.referer || wishlists_path, notice: 'Removed from wishlist.' }
      format.json { render json: { success: true, message: 'Removed from wishlist' } }
    end
  end

  def destroy_by_product
    @product = Product.find(params[:product_id])
    @wishlist = current_customer.wishlists.find_by(product: @product)
    
    if @wishlist
      @wishlist.destroy
      respond_to do |format|
        format.html { redirect_to request.referer || product_path(@product), notice: 'Removed from wishlist.' }
        format.json { render json: { success: true, message: 'Removed from wishlist' } }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer || product_path(@product), alert: 'Item not in wishlist.' }
        format.json { render json: { success: false, message: 'Not in wishlist' }, status: :not_found }
      end
    end
  end
end