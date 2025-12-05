# app/controllers/ratings_controller.rb
class RatingsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_product

  def create
    @rating = @product.ratings.build(rating_params)
    @rating.customer = current_customer

    if @rating.save
      redirect_to @product, notice: 'Thank you for your rating!'
    else
      redirect_to @product, alert: @rating.errors.full_messages.join(', ')
    end
  end

  def update
    @rating = @product.ratings.find_by(customer: current_customer)
    
    if @rating&.update(rating_params)
      redirect_to @product, notice: 'Your rating has been updated.'
    else
      redirect_to @product, alert: 'Unable to update rating.'
    end
  end

  def destroy
    @rating = @product.ratings.find_by(customer: current_customer)
    
    if @rating&.destroy
      redirect_to @product, notice: 'Your rating has been removed.'
    else
      redirect_to @product, alert: 'Unable to remove rating.'
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