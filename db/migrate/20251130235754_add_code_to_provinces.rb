class AddCodeToProvinces < ActiveRecord::Migration[8.0]
  def change
    add_column :province_code, :code, :string
  end
end
