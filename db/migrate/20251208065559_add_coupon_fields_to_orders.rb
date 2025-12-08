class AddCouponFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :discount_amount, :decimal
    add_column :orders, :coupon_code, :string
  end
end
