# app/admin/coupons.rb
ActiveAdmin.register Coupon do
  permit_params :code, :discount_type, :discount_value, :active, 
                :expires_at, :usage_limit, :minimum_purchase

  index do
    selectable_column
    id_column
    column :code
    column :discount_type
    column :discount_value
    column :active
    column :times_used
    column :usage_limit
    column :expires_at
    column :created_at
    actions
  end

  filter :code
  filter :discount_type
  filter :active
  filter :expires_at
  filter :created_at

  form do |f|
    f.inputs do
      f.input :code, hint: 'Uppercase letters and numbers only'
      f.input :discount_type, as: :select, collection: [['Percentage', 'percentage'], ['Fixed Amount', 'fixed']]
      f.input :discount_value, hint: 'For percentage: enter 10 for 10%. For fixed: enter dollar amount'
      f.input :active
      f.input :expires_at, as: :datepicker
      f.input :usage_limit, hint: 'Leave blank for unlimited uses'
      f.input :minimum_purchase, hint: 'Minimum cart total required to use this coupon'
    end
    f.actions
  end

  show do
    attributes_table do
      row :code
      row :discount_type
      row :discount_value
      row :display_discount
      row :active
      row :times_used
      row :usage_limit
      row :expires_at
      row :minimum_purchase
      row :created_at
      row :updated_at
    end
  end
end