class CreateWishlists < ActiveRecord::Migration[7.0]
  def change
    create_table :wishlists do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end

    # Ensure a customer can only add a product once to their wishlist
    add_index :wishlists, [:customer_id, :product_id], unique: true
  end
end