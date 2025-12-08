class CreateCoupons < ActiveRecord::Migration[8.0]
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :discount_type
      t.decimal :discount_value
      t.boolean :active
      t.datetime :expires_at
      t.integer :usage_limit
      t.integer :times_used
      t.decimal :minimum_purchase

      t.timestamps
    end
  end
end
