class AddTagsToCoupons < ActiveRecord::Migration[8.0]
  def change
    add_column :coupons, :tags, :text
  end
end
