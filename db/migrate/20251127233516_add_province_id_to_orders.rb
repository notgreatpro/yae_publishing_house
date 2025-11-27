class AddProvinceIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :province, foreign_key: true unless column_exists?(:orders, :province_id)
  end
end