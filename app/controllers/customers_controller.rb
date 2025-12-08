# app/controllers/customers_controller.rb
class CustomersController < ApplicationController
  before_action :authenticate_customer!

  def show
    @customer = current_customer
    @orders = @customer.orders.order(created_at: :desc).limit(5)
    @ratings = @customer.ratings.includes(:product).order(created_at: :desc)
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    
    # Check if we need to validate password (email change or password change)
    if customer_params[:password].present? || email_changed?
      # Use update_with_password for password changes or email changes
      if @customer.update_with_password(customer_params_with_password)
        bypass_sign_in(@customer) # Sign in the customer bypassing validation in case their password changed
        redirect_to customer_profile_path, notice: 'Profile updated successfully!'
      else
        render :edit, status: :unprocessable_entity
      end
    else
      # Regular update without password validation (for name, address, phone, profile picture)
      # Use update_without_password to skip current_password validation
      if @customer.update_without_password(customer_params_without_password)
        redirect_to customer_profile_path, notice: 'Profile updated successfully!'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def remove_profile_picture
    @customer = current_customer
    @customer.profile_picture.purge
    redirect_to edit_customer_profile_path, notice: 'Profile picture removed successfully!'
  end

  private

  def customer_params
    params.require(:customer).permit(
      :first_name, 
      :last_name, 
      :email,
      :phone,
      :password,
      :password_confirmation,
      :current_password,
      :address_line1, 
      :address_line2, 
      :city, 
      :postal_code, 
      :province_id,
      :profile_picture
    )
  end

  def customer_params_with_password
    customer_params
  end

  def customer_params_without_password
    customer_params.except(:password, :password_confirmation, :current_password)
  end

  def email_changed?
    customer_params[:email].present? && customer_params[:email] != @customer.email
  end
end