# app/controllers/ratings_controller.rb
class RatingsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_product

  def create
    @rating = @product.ratings.build(rating_params)
    @rating.customer = current_customer

    if @rating.save
      redirect_to @product, notice: 'Thank you for your review!'
    else
      redirect_to @product, alert: @rating.errors.full_messages.join(', ')
    end
  end

  def update
    @rating = @product.ratings.find(params[:id])
    
    # Make sure the rating belongs to the current customer
    if @rating.customer != current_customer
      redirect_to @product, alert: 'You can only edit your own reviews.'
      return
    end
    
    if @rating.update(rating_params)
      redirect_to @product, notice: 'Your review has been updated.'
    else
      redirect_to @product, alert: 'Unable to update review.'
    end
  end

  def destroy
    @rating = @product.ratings.find(params[:id])
    
    # Make sure the rating belongs to the current customer
    if @rating.customer != current_customer
      redirect_to @product, alert: 'You can only delete your own reviews.'
      return
    end
    
    if @rating.destroy
      redirect_to @product, notice: 'Your review has been removed.'
    else
      redirect_to @product, alert: 'Unable to remove review.'
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def rating_params
    params.require(:rating).permit(:score, :review)
  end
end