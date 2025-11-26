# app/helpers/application_helper.rb
module ApplicationHelper
  def cart_count
    cart = session[:cart] || {}
    cart.values.sum
  end
end