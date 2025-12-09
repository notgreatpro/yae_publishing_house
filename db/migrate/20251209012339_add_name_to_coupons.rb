class AddNameToCoupons < ActiveRecord::Migration[8.0]
  def change
    add_column :coupons, :name, :string
  end
end
