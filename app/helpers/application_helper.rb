# app/helpers/application_helper.rb
module ApplicationHelper
  def cart_count
    cart = session[:cart] || {}
    cart.values.sum
  end

  def order_status_color(status)
    case status
    when 'pending'
      'warning'
    when 'paid'
      'info'
    when 'shipped'
      'primary'
    when 'delivered'
      'success'
    when 'cancelled'
      'danger'
    else
      'secondary'
    end
  end
end