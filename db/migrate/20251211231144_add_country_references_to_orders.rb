class AddCountryReferencesToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :country, foreign_key: true
    add_reference :customers, :country, foreign_key: true
    
    change_column_null :orders, :province_id, true
    change_column_null :customers, :province_id, true
    
    add_column :orders, :is_canada, :boolean, default: true
    add_column :customers, :is_canada, :boolean, default: true
  end
end