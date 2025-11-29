ActiveAdmin.register Order do
  permit_params :status, :customer_id, :total_amount, :tax_amount, :subtotal, 
                :order_status, :payment_method, :shipping_address, :city, 
                :country, :postal_code, :province_id

  index do
    selectable_column
    id_column
    column :customer do |order|
      order.customer&.email || "Guest"
    end
    column 'Total', :total_amount do |order|
      number_to_currency(order.total_amount)
    end
    column :status do |order|
      status_tag(order.status)
    end
    column :payment_method
    column :created_at
    actions
  end

  filter :customer
  filter :status, as: :select, collection: ['new', 'paid', 'shipped', 'cancelled', 'delivered']
  filter :payment_method, as: :select, collection: ['credit_card', 'stripe', 'paypal']
  filter :created_at

  show do
    attributes_table do
      row :id
      row :customer do |order|
        link_to order.customer.email, admin_customer_path(order.customer) if order.customer
      end
      row :status do |order|
        status_tag(order.status)
      end
      row :subtotal do |order|
        number_to_currency(order.subtotal)
      end
      row :tax_amount do |order|
        number_to_currency(order.tax_amount)
      end
      row :total_amount do |order|
        number_to_currency(order.total_amount)
      end
      row :payment_method
      row :stripe_payment_id if order.stripe_payment_id.present?
      row :province
      row :shipping_address
      row :city
      row :country
      row :postal_code
      row :order_date
      row :shipped_date
      row :delivered_date
      row :created_at
    end

    panel 'Order Items' do
      table_for order.order_items do
        column :product do |item|
          link_to item.product.name, admin_product_path(item.product)
        end
        column :quantity
        column :price do |item|
          number_to_currency(item.price)
        end
        column 'Line Total' do |item|
          number_to_currency(item.quantity * item.price)
        end
      end
    end
  end

  form do |f|
    f.inputs 'Order Status' do
      f.input :status, as: :select, collection: ['new', 'paid', 'shipped', 'cancelled', 'delivered']
      f.input :order_status
      f.input :payment_method, as: :select, collection: ['credit_card', 'stripe', 'paypal']
    end
    f.actions
  end

  # Custom action to mark as shipped
  member_action :ship, method: :put do
    resource.update(status: 'shipped', shipped_date: Time.current)
    redirect_to admin_order_path(resource), notice: 'Order marked as shipped'
  end

  # Custom action to mark as delivered
  member_action :deliver, method: :put do
    resource.update(status: 'delivered', delivered_date: Time.current)
    redirect_to admin_order_path(resource), notice: 'Order marked as delivered'
  end

  action_item :ship, only: :show, if: proc { order.status == 'paid' } do
    link_to 'Mark as Shipped', ship_admin_order_path(order), method: :put, class: 'button'
  end

  action_item :deliver, only: :show, if: proc { order.status == 'shipped' } do
    link_to 'Mark as Delivered', deliver_admin_order_path(order), method: :put, class: 'button'
  end
end