class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.datetime :order_date
      t.decimal :total_amount
      t.string :order_status
      t.string :payment_method
      t.string :shipping_address
      t.string :city
      t.string :country
      t.string :postal_code
      t.datetime :shipped_date
      t.datetime :delivered_date

      t.timestamps
    end
  end
end
