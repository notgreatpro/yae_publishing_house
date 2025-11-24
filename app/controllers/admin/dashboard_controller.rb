# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  before_action :require_admin

  layout "admin" # Use a custom layout for admin area if desired

  private

  def require_admin
    unless current_admin
      redirect_to admin_login_path, alert: "Please log in as admin"
    end
  end

  # Implement current_admin based on your authentication (example below)
  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end

  helper_method :current_admin
end