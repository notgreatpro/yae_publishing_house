# app/controllers/products_controller.rb
# Customer-facing controller (PUBLIC - no login required)
class ProductsController < ApplicationController
  # Note: No before_action for authentication - this is public!
  # No admin layout - uses default application layout
  
  # GET / or GET /products
  # Feature 2.1 - Navigate through products on front page ⭐
  def index
    # Feature 2.2 - Load categories for navigation (2%)
    @categories = Category.order(:category_name)
    
    @products = Product.includes(:category, :authors)
                      .order(created_at: :desc)
    
    # Feature 2.4 - Filtering (2%)
    case params[:filter]
    when 'new'
      # New products added within the past 3 days
      @products = @products.where('created_at >= ?', 3.days.ago)
    when 'updated'
      # Recently updated (within 3 days) but NOT newly created
      @products = @products.where('updated_at >= ?', 3.days.ago)
                          .where('created_at < ?', 3.days.ago)
    when 'sale'
      # On sale products (you'll need to add this column if you want to use it)
      @products = @products.where(on_sale: true)
    end
    
    # Feature 2.5 - Pagination (2%)
    @products = @products.page(params[:page]).per(12)
  end

  # GET /products/:id
  # Feature 2.3 - View product details on own page ⭐
  def show
    @product = Product.includes(:category, :authors).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Product not found'
  end
  
  # Future: Feature 2.6 - Search by keyword and category
  def search
    @products = Product.includes(:category, :authors)
    
    # Keyword search in title or description
    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @products = @products.where(
        'title LIKE ? OR description LIKE ?', 
        keyword, keyword
      )
    end
    
    # Filter by category
    if params[:category_id].present? && params[:category_id] != ''
      @products = @products.where(category_id: params[:category_id])
    end
    
    @products = @products.page(params[:page]).per(12)
    render :index
  end
end