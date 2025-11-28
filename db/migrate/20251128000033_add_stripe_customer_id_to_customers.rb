class AddStripeCustomerIdToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :stripe_customer_id, :string
    add_index :customers, :stripe_customer_id
  end
end