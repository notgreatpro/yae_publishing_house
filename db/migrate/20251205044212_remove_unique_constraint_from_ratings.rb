class RemoveUniqueConstraintFromRatings < ActiveRecord::Migration[7.0]
  def up
    # Remove the unique index
    remove_index :ratings, [:product_id, :customer_id] if index_exists?(:ratings, [:product_id, :customer_id])
    
    # Add back the index without unique constraint
    add_index :ratings, [:product_id, :customer_id] unless index_exists?(:ratings, [:product_id, :customer_id])
  end

  def down
    # If rolling back, restore unique constraint
    remove_index :ratings, [:product_id, :customer_id] if index_exists?(:ratings, [:product_id, :customer_id])
    add_index :ratings, [:product_id, :customer_id], unique: true
  end
end