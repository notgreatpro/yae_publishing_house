# app/admin/coupons.rb
ActiveAdmin.register Coupon do
  permit_params :name, :code, :discount_type, :discount_value, :active, 
                :expires_at, :usage_limit, :minimum_purchase,
                :discount_category, :applies_to_quantity, 
                :first_time_buyer_only, :flash_sale_ends_at, :tag_list

  index do
    selectable_column
    id_column
    column :name
    column :code
    column :discount_category
    column :discount_type
    column :discount_value
    column :active
    column :times_used
    column :usage_limit
    column :expires_at
    column :flash_sale_ends_at
    column :created_at
    actions
  end

  filter :code
  filter :discount_category, as: :select, collection: Coupon::DISCOUNT_CATEGORIES
  filter :discount_type
  filter :active
  filter :expires_at
  filter :flash_sale_ends_at
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name, hint: 'Friendly name for this coupon (e.g., "Summer Sale 2024")'
      f.input :code, hint: 'Uppercase letters and numbers only'
      f.input :discount_category, as: :select, collection: Coupon::DISCOUNT_CATEGORIES.map { |c| [c.titleize, c] }, include_blank: 'General'
      f.input :discount_type, as: :select, collection: [['Percentage', 'percentage'], ['Fixed Amount', 'fixed']]
      f.input :discount_value, hint: 'For percentage: enter 10 for 10%. For fixed: enter dollar amount'
      f.input :active
      f.input :expires_at, as: :datepicker
      f.input :usage_limit, hint: 'Leave blank for unlimited uses'
      f.input :minimum_purchase, hint: 'Minimum cart total required to use this coupon'
      f.input :discount_category, as: :select, collection: Coupon::DISCOUNT_CATEGORIES, include_blank: true
      
      # Bulk discount fields
      f.input :applies_to_quantity, hint: 'For bulk discounts: minimum quantity required (e.g., Buy 3 or more)'
      
      # First-time buyer field
      f.input :first_time_buyer_only, hint: 'Check this for first-time buyer discounts'
      
      # Flash sale field
      f.input :flash_sale_ends_at, as: :datepicker, hint: 'For flash sales: when the sale ends'
      f.input :tag_list, as: :string, hint: 'Comma-separated tags (e.g., "holiday, winter, bestseller")'
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :code
      row :discount_category
      row :discount_type
      row :discount_value
      row "Tags" do |coupon|
        coupon.tags&.join(', ')
      end
      row :display_discount
      row :active
      row :times_used
      row :usage_limit
      row :expires_at
      row :discount_category
      row :minimum_purchase
      row :applies_to_quantity
      row :first_time_buyer_only
      row :flash_sale_ends_at
      row :time_remaining if resource.flash_sale?
      row :created_at
      row :updated_at
    end
  end
end