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
    
    if @customer.update(customer_params)
      redirect_to customer_profile_path, notice: 'Profile updated successfully!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(
      :first_name, 
      :last_name, 
      :email,
      :address_line1, 
      :address_line2, 
      :city, 
      :postal_code, 
      :province_id
    )
  end
end