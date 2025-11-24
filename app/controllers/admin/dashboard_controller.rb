class Admin::DashboardController < ApplicationController
  layout 'admin'
  before_action :require_admin_login

  def index
    @total_products = Product.count
    @total_categories = Category.count
    @total_authors = Author.count
    @total_customers = Customer.count
  end

  private

  def require_admin_login
    unless session[:admin_id]
      redirect_to admin_login_path, alert: "Please log in first"
    end
  end
end