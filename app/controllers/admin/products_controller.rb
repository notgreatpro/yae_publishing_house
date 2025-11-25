class Admin::ProductsController < ApplicationController
  layout 'admin'
  before_action :require_admin_login
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /admin/products
  def index
    @products = Product.includes(:category, :authors).order(created_at: :desc).page(params[:page]).per(20)
  end

  # GET /admin/products/:id
  def show
  end

  # GET /admin/products/new
  def new
    @product = Product.new
    @categories = Category.all
    @authors = Author.all
  end

  # POST /admin/products
  def create
    @product = Product.new(product_params)
    @product.created_by_id = current_admin.id

    if @product.save
      # Handle author associations
      if params[:product][:author_ids].present?
        params[:product][:author_ids].reject(&:blank?).each do |author_id|
          @product.product_authors.create(author_id: author_id)
        end
      end

      redirect_to admin_products_path, notice: "Product '#{@product.title}' created successfully!"
    else
      @categories = Category.all
      @authors = Author.all
      render :new, status: :unprocessable_entity
    end
  end

  # GET /admin/products/:id/edit
  def edit
    @categories = Category.all
    @authors = Author.all
  end

  # PATCH/PUT /admin/products/:id
  def update
    if @product.update(product_params)
      # Update author associations
      if params[:product][:author_ids].present?
        @product.product_authors.destroy_all
        params[:product][:author_ids].reject(&:blank?).each do |author_id|
          @product.product_authors.create(author_id: author_id)
        end
      end

      redirect_to admin_products_path, notice: "Product '#{@product.title}' updated successfully!"
    else
      @categories = Category.all
      @authors = Author.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/products/:id
  def destroy
    title = @product.title
    @product.destroy
    redirect_to admin_products_path, notice: "Product '#{title}' deleted successfully!"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :title, :isbn, :description, :current_price, :stock_quantity,
      :category_id, :publisher, :publication_date, :pages, :language,
      :cover_image
    )
  end

  def require_admin_login
    unless session[:admin_id]
      redirect_to admin_login_path, alert: "Please log in first"
    end
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end
end