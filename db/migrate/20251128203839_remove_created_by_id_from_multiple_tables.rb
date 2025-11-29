class RemoveCreatedByIdFromMultipleTables < ActiveRecord::Migration[7.0]
  def change
    # Remove foreign keys if they exist
    if foreign_key_exists?(:categories, :admins)
      remove_foreign_key :categories, :admins
    end
    
    if foreign_key_exists?(:products, :admins)
      remove_foreign_key :products, :admins
    end
    
    if foreign_key_exists?(:authors, :admins)
      remove_foreign_key :authors, :admins
    end
    
    # Remove the columns
    remove_column :categories, :created_by_id, :integer if column_exists?(:categories, :created_by_id)
    remove_column :products, :created_by_id, :integer if column_exists?(:products, :created_by_id)
    remove_column :authors, :created_by_id, :integer if column_exists?(:authors, :created_by_id)
  end
end