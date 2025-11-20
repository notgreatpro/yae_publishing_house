class CreateAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :full_name
      t.string :role
      t.datetime :last_login

      t.timestamps
    end
  end
end
