class AddAddressToCustomers < ActiveRecord::Migration[7.2]
  def change
    # Add new columns
    add_column :customers, :address_line1, :string unless column_exists?(:customers, :address_line1)
    add_column :customers, :address_line2, :string unless column_exists?(:customers, :address_line2)
    add_column :customers, :postal_code, :string unless column_exists?(:customers, :postal_code)
    add_reference :customers, :province, foreign_key: true unless column_exists?(:customers, :province_id)
  end
end