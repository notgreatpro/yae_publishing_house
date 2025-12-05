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
    
    # Track recently viewed products
    track_recently_viewed(@product)
    
    # Get related products (same category, excluding current product)
    @related_products = Product
      .where(category_id: @product.category_id)
      .where.not(id: @product.id)
      .order('RANDOM()')
      .limit(6)
    
    # If not enough related products, add random products
    if @related_products.size < 6
      additional_products = Product
        .where.not(id: [@product.id] + @related_products.pluck(:id))
        .order('RANDOM()')
        .limit(6 - @related_products.size)
      @related_products = (@related_products.to_a + additional_products.to_a).first(6)
    end
    
    # Get recently viewed products from session
    @recently_viewed_products = get_recently_viewed_products
    
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Product not found'
  end
  
  # Feature 2.6 - Search by keyword and category (4%) ⭐
  def search
    @categories = Category.order(:category_name)
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
    
    @products = @products.order(created_at: :desc).page(params[:page]).per(12)
    
    # Render the index view with search results
    render :index
  end

  private

  def track_recently_viewed(product)
    # Initialize recently_viewed in session if it doesn't exist
    session[:recently_viewed] ||= []
    
    # Remove the current product if it's already in the list
    session[:recently_viewed].delete(product.id)
    
    # Add current product to the beginning
    session[:recently_viewed].unshift(product.id)
    
    # Keep only the last 10 viewed products
    session[:recently_viewed] = session[:recently_viewed].first(10)
  end

  def get_recently_viewed_products
    return [] unless session[:recently_viewed].present?
    
    # Get products, excluding the current product
    product_ids = session[:recently_viewed].reject { |id| id == @product.id }
    
    # Fetch products maintaining the order and limit to 6
    Product.where(id: product_ids.first(6))
           .sort_by { |product| product_ids.index(product.id) }
  end
end