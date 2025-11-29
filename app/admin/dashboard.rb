ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent Orders' do
          if Order.any?
            table_for Order.order(created_at: :desc).limit(10) do
              column('Order ID') { |order| link_to("##{order.id}", admin_order_path(order)) }
              column('Customer') { |order| order.customer&.email || order.customer&.name }
              column('Total') { |order| number_to_currency(order.total_amount) }
              column('Status') { |order| status_tag(order.status) }
              column('Date') { |order| order.created_at.strftime('%b %d, %Y') }
            end
          else
            para "No orders yet"
          end
        end
      end

      column do
        panel 'Store Statistics' do
          para "Total Products: #{Product.count}"
          para "Total Orders: #{Order.count}"
          para "Total Customers: #{Customer.count}"
          para "Total Categories: #{Category.count}"
          para "Revenue Today: #{number_to_currency(Order.where('created_at >= ?', Date.today).sum(:total_amount))}"
        end

        panel 'Low Stock Products' do
          low_stock = Product.where('stock_quantity < ?', 5).limit(5)
          if low_stock.any?
            table_for low_stock do
              column('Product') { |product| link_to(product.name, admin_product_path(product)) }
              column('Stock') { |product| product.stock_quantity }
            end
          else
            para "All products are well stocked!"
          end
        end
      end
    end
  end
end