class AddDiscountFeaturesToCoupons < ActiveRecord::Migration[8.0]
  def change
    add_column :coupons, :discount_category, :string
    add_column :coupons, :applies_to_quantity, :integer
    add_column :coupons, :first_time_buyer_only, :boolean
    add_column :coupons, :flash_sale_ends_at, :datetime
  end
end
