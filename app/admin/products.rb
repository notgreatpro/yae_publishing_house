ActiveAdmin.register Product do
  menu label: "Books", priority: 2
  
  permit_params :title, :isbn, :description, :current_price, :stock_quantity, 
                :publisher, :pages, :language, :category_id, :cover_image,
                author_ids: []

  # Index page - list all products/books (Simple standard version)
  index do
    selectable_column
    id_column
    
    column :cover_image do |product|
      if product.cover_image.attached?
        image_tag url_for(product.cover_image), size: "50x75"
      else
        "No image"
      end
    end
    
    column :title
    column :isbn
    column :authors do |product|
      product.authors.map(&:author_name).join(", ")
    end
    column :category do |product|
      product.category&.category_name
    end
    column :current_price do |product|
      number_to_currency(product.current_price)
    end
    column :stock_quantity
    column :publisher
    column :created_at
    actions
  end

  # Filters for searching
  filter :title
  filter :isbn
  filter :category, as: :select, collection: -> { Category.all.map { |c| [c.category_name, c.id] } }
  filter :authors, as: :select, collection: -> { Author.all.map { |a| [a.author_name, a.id] } }
  filter :current_price
  filter :stock_quantity
  filter :publisher
  filter :created_at

  # Scopes for quick filtering
  scope :all, default: true
  scope("Low Stock") { |products| products.where('stock_quantity < ?', 5) }
  scope("Out of Stock") { |products| products.where(stock_quantity: 0) }
  scope("Recently Added") { |products| products.where('created_at > ?', 7.days.ago) }

  # Form for creating/editing products/books
  form do |f|
    f.inputs 'Book Details' do
      f.input :title, label: "Book Title"
      f.input :isbn, label: "ISBN", hint: "International Standard Book Number"
      f.input :description, as: :text, input_html: { rows: 6 }
      f.input :current_price, label: "Price ($)"
      f.input :stock_quantity, label: "Stock Quantity"
      f.input :publisher
      f.input :pages, label: "Number of Pages"
      f.input :language, hint: "e.g., English, French, Spanish"
    end

    f.inputs 'Category & Authors' do
      f.input :category, 
              as: :select, 
              collection: Category.all.map { |c| [c.category_name, c.id] },
              include_blank: "Select a category"
      
      # Feature 4.2.5 - Many-to-many without directly manipulating join table
      f.input :authors, 
              as: :check_boxes, 
              collection: Author.all.map { |a| [a.author_name, a.id] },
              hint: "Select one or more authors for this book"
    end

    # Image upload (Feature 1.3) - Using Active Storage
    f.inputs 'Cover Image' do
      f.input :cover_image, as: :file, hint: "Upload book cover image"
      
      # Show existing image if editing
      if f.object.cover_image.attached?
        div do
          h4 "Current Cover Image:"
          image_tag url_for(f.object.cover_image), size: "200x300"
        end
      end
    end

    f.actions
  end

  # Show page - detailed view
  show do
    attributes_table do
      row :id
      
      row :cover_image do |product|
        if product.cover_image.attached?
          image_tag url_for(product.cover_image), size: "300x450"
        else
          "No cover image uploaded"
        end
      end
      
      row :title
      row :isbn
      row :description do |product|
        simple_format(product.description)
      end
      
      row :authors do |product|
        if product.authors.any?
          product.authors.map do |author|
            link_to author.author_name, admin_author_path(author)
          end.join(", ").html_safe
        else
          "No authors assigned"
        end
      end
      
      row :category do |product|
        if product.category
          link_to product.category.category_name, admin_category_path(product.category)
        else
          "No category assigned"
        end
      end
      
      row :current_price do |product|
        number_to_currency(product.current_price)
      end
      
      row :stock_quantity do |product|
        if product.stock_quantity == 0
            status_tag("Out of Stock", class: "error")
        elsif product.stock_quantity < 5
            status_tag("Low Stock: #{product.stock_quantity}", class: "warning")
        else
            status_tag("In Stock: #{product.stock_quantity}", class: "ok")
        end
    end
      
      row :publisher
      row :pages
      row :language
      row :created_at
      row :updated_at
    end

    panel "Sales History" do
      if product.order_items.any?
        table_for product.order_items do
          column "Order ID" do |item|
            link_to "##{item.order.id}", admin_order_path(item.order)
          end
          column "Customer" do |item|
            item.order.customer.full_name
          end
          column "Quantity", :quantity
          column "Price at Purchase" do |item|
            number_to_currency(item.price_at_purchase)
          end
          column "Line Total" do |item|
            number_to_currency(item.quantity * item.price_at_purchase)
          end
          column "Date" do |item|
            item.created_at.strftime('%b %d, %Y')
          end
        end
      else
        para "No sales yet for this book"
      end
    end
  end

 # Bulk actions
  batch_action :mark_out_of_stock do |ids|
    batch_action_collection.find(ids).each do |product|
      product.update(stock_quantity: 0)
    end
    redirect_to collection_path, notice: "Books marked as out of stock"
  end

  batch_action :add_stock, form: -> { { quantity: :number } } do |ids, inputs|
    batch_action_collection.find(ids).each do |product|
      product.update(stock_quantity: product.stock_quantity + inputs[:quantity].to_i)
    end
    redirect_to collection_path, notice: "Stock quantity updated for selected books"
  end
end