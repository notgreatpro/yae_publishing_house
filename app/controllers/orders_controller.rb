class OrdersController < ApplicationController
  before_action :authenticate_customer!

  def confirmation
    @order = current_customer.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Order not found'
  end

  def show
    @order = current_customer.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Order not found'
  end

  def index
    @orders = current_customer.orders.order(created_at: :desc)
  end
end