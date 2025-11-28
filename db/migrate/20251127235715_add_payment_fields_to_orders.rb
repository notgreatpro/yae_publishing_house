class AddPaymentFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :stripe_payment_id, :string
    add_column :orders, :stripe_customer_id, :string
    add_index :orders, :stripe_payment_id
    add_index :orders, :stripe_customer_id
  end
end