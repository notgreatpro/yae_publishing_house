class AddAddressFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    # Only add columns that don't exist yet
    # Check the output from Order.column_names and comment out any that already exist
    
    add_column :orders, :address_line1, :string unless column_exists?(:orders, :address_line1)
    add_column :orders, :address_line2, :string unless column_exists?(:orders, :address_line2)
    # add_column :orders, :city, :string  # ALREADY EXISTS - commented out
    add_column :orders, :postal_code, :string unless column_exists?(:orders, :postal_code)
    
    # Add these only if they don't exist
    add_column :orders, :subtotal, :decimal, precision: 10, scale: 2, default: 0.0 unless column_exists?(:orders, :subtotal)
    add_column :orders, :tax_amount, :decimal, precision: 10, scale: 2, default: 0.0 unless column_exists?(:orders, :tax_amount)
    add_column :orders, :total_amount, :decimal, precision: 10, scale: 2, default: 0.0 unless column_exists?(:orders, :total_amount)
    add_column :orders, :gst_rate, :decimal, precision: 5, scale: 2, default: 0.0 unless column_exists?(:orders, :gst_rate)
    add_column :orders, :pst_rate, :decimal, precision: 5, scale: 2, default: 0.0 unless column_exists?(:orders, :pst_rate)
    add_column :orders, :hst_rate, :decimal, precision: 5, scale: 2, default: 0.0 unless column_exists?(:orders, :hst_rate)
  end
end