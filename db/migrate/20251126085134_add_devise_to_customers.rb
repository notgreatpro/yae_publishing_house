# frozen_string_literal: true

class AddDeviseToCustomers < ActiveRecord::Migration[7.1]
  def up
    # Only add columns that don't exist
    unless column_exists?(:customers, :email)
      add_column :customers, :email, :string, null: false, default: ""
    end
    
    unless column_exists?(:customers, :encrypted_password)
      add_column :customers, :encrypted_password, :string, null: false, default: ""
    end
    
    unless column_exists?(:customers, :reset_password_token)
      add_column :customers, :reset_password_token, :string
    end
    
    unless column_exists?(:customers, :reset_password_sent_at)
      add_column :customers, :reset_password_sent_at, :datetime
    end
    
    unless column_exists?(:customers, :remember_created_at)
      add_column :customers, :remember_created_at, :datetime
    end

    # Add indexes only if they don't exist
    unless index_exists?(:customers, :email)
      add_index :customers, :email, unique: true
    end
    
    unless index_exists?(:customers, :reset_password_token)
      add_index :customers, :reset_password_token, unique: true
    end
  end

  def down
    # Uncomment if you need to rollback
    # remove_column :customers, :encrypted_password
    # remove_column :customers, :reset_password_token
    # remove_column :customers, :reset_password_sent_at
    # remove_column :customers, :remember_created_at
  end
end