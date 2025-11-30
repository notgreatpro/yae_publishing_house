class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :address_line1, :address_line2, :city, :province_id, :postal_code])
  devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :address_line1, :address_line2, :city, :province_id, :postal_code])
end

  # Redirect customers after sign up
  def after_sign_up_path_for(resource)
    if resource.is_a?(Customer)
      root_path # Redirect to products#index
    else
      super
    end
  end

  # Redirect after sign in
  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_root_path # Admin dashboard
    elsif resource.is_a?(Customer)
      root_path # Products page
    else
      super
    end
  end

  # Redirect after sign out
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin_user
      new_admin_user_session_path
    else
      root_path
    end
  end
end