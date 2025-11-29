class AddUsernameToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :username, :string
    add_index :admin_users, :username, unique: true
  end
end