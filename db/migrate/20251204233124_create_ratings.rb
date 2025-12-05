class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.references :product, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.integer :score, null: false
      t.text :review
      t.timestamps
    end

    # Add index for faster lookups (removed unique constraint to allow multiple reviews per customer)
    add_index :ratings, [:product_id, :customer_id]
    
    # Add average rating and rating count to products table
    add_column :products, :average_rating, :decimal, precision: 3, scale: 2, default: 0.0
    add_column :products, :ratings_count, :integer, default: 0
  end
end