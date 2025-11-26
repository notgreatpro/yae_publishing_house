# app/controllers/categories_controller.rb
# Feature 2.2 - Navigate through products by category (2%)
class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products
                        .includes(:authors)
                        .order(created_at: :desc)
                        .page(params[:page])
                        .per(12)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Category not found'
  end
end