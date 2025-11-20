class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :shipping_address
      t.string :city
      t.string :country
      t.string :postal_code
      t.datetime :last_login

      t.timestamps
    end
  end
end
