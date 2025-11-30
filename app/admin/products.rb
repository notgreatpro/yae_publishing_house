ActiveAdmin.register Customer do
  menu priority: 5
  
  permit_params :email, :password, :password_confirmation, :first_name, :last_name,
                :address_line1, :address_line2, :city, :postal_code, :province_id

  # Index page
  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :city
    column :province do |customer|
      customer.province&.name
    end
    column "Orders Count" do |customer|
      customer.orders.count
    end
    column :created_at
    actions
  end

  # Filters
  filter :email
  filter :first_name
  filter :last_name
  filter :city
  filter :province
  filter :created_at

  # Show page
  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :full_name
      row :address_line1
      row :address_line2
      row :city
      row :postal_code
      row :province do |customer|
        customer.province&.name
      end
      row :created_at
      row :updated_at
    end

    panel "Orders" do
      if customer.orders.any?
        table_for customer.orders do
          column "Order ID" do |order|
            link_to "##{order.id}", admin_order_path(order)
          end
          column "Total" do |order|
            number_to_currency(order.total_amount)
          end
          column "Status" do |order|
            status_tag order.status
          end
          column "Date" do |order|
            order.created_at.strftime('%b %d, %Y')
          end
        end
      else
        para "No orders yet"
      end
    end
  end

  # Form
  form do |f|
    f.inputs 'Customer Information' do
      f.input :email
      f.input :first_name
      f.input :last_name
      
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end

    f.inputs 'Address (Optional)' do
      f.input :address_line1
      f.input :address_line2
      f.input :city
      f.input :postal_code, hint: "Format: A1A 1A1"
      f.input :province, 
              as: :select,
              collection: Province.all.map { |p| [p.name, p.id] },
              include_blank: "Select a province"
    end

    f.actions
  end

  # Ransack methods
  def self.ransackable_associations(auth_object = nil)
    ["orders", "province"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "first_name", "last_name", "address_line1", "address_line2", 
     "city", "postal_code", "province_id", "created_at", "updated_at"]
  end
end