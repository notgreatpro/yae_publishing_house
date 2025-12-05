ActiveAdmin.register Product do
  menu priority: 2
  
  permit_params :title, :description, :isbn, :current_price,
                :stock_quantity, :category_id, :publisher, :publication_date,
                :pages, :language, :cover_image, :on_sale, author_ids: []

  # Index page
  index do
    selectable_column
    id_column
    column "Cover" do |product|
      if product.cover_image.attached?
        image_tag product.thumbnail, size: "50x75"
      else
        "No image"
      end
    end
    column :title
    column "Authors" do |product|
      product.authors.map(&:author_name).join(", ")
    end
    column :category do |product|
      product.category&.category_name
    end
    column :isbn
    column "Price" do |product|
      number_to_currency(product.current_price)
    end
    column :stock_quantity
    column "On Sale" do |product|
      status_tag product.on_sale ? 'Yes' : 'No', product.on_sale ? :ok : nil
    end
    column :created_at
    actions
  end

  # Filters
  filter :title
  filter :authors
  filter :category
  filter :isbn
  filter :current_price
  filter :stock_quantity
  filter :publisher
  filter :language
  filter :publication_date
  filter :on_sale, as: :select, collection: [['On Sale', true], ['Not On Sale', false]]
  filter :created_at

  # Form
  form do |f|
    f.inputs 'Book Information' do
      f.input :title
      f.input :authors, 
              as: :check_boxes, 
              collection: Author.all.map { |a| [a.author_name, a.id] },
              hint: "Select one or more authors"
      f.input :category,
              as: :select,
              collection: Category.all.map { |c| [c.category_name, c.id] },
              include_blank: "Select a category"
      f.input :description, as: :text, input_html: { rows: 10 }
      f.input :isbn, hint: "ISBN-13 format"
      f.input :publisher
      f.input :publication_date, as: :datepicker, hint: "Date the book was published"
      f.input :pages, hint: "Number of pages"
      f.input :language, hint: "e.g., English, French, etc."
    end
    
    f.inputs 'Pricing & Stock' do
      f.input :current_price, label: "Price", hint: "Enter amount in dollars"
      f.input :stock_quantity, hint: "Number of copies in stock"
      f.input :on_sale, label: "On Sale", as: :boolean, hint: "Check to display 'ON SALE' badge on product"
    end
    
    f.inputs 'Cover Image' do
      if f.object.persisted? && f.object.cover_image.attached?
        f.input :cover_image, 
                as: :file, 
                hint: image_tag(f.object.medium_image, height: 150) 
      else
        f.input :cover_image, 
                as: :file, 
                hint: "Upload a cover image (JPG, PNG)"
      end
    end
    
    f.actions
  end

  # Show page
  show do
    attributes_table do
      row "Cover Image" do |product|
        if product.cover_image.attached?
          image_tag product.large_image, height: 300
        else
          "No cover image"
        end
      end
      row :title
      row "Authors" do |product|
        product.authors.map { |a| link_to a.author_name, admin_author_path(a) }.join(", ").html_safe
      end
      row :category do |product|
        link_to product.category.category_name, admin_category_path(product.category) if product.category
      end
      row :description do |product|
        simple_format(product.description)
      end
      row :isbn
      row :publisher
      row :publication_date
      row :pages
      row :language
      row "Price" do |product|
        number_to_currency(product.current_price)
      end
      row :stock_quantity
      row "On Sale" do |product|
        status_tag product.on_sale ? 'Yes' : 'No', product.on_sale ? :ok : nil
      end
      row :created_at
      row :updated_at
    end

    panel "Order History" do
      if product.order_items.any?
        table_for product.order_items do
          column "Order" do |item|
            link_to "##{item.order.id}", admin_order_path(item.order)
          end
          column "Customer" do |item|
            item.order.customer.email if item.order.customer
          end
          column "Quantity", :quantity
          column "Price" do |item|
            number_to_currency(item.price_at_purchase)
          end
          column "Date" do |item|
            item.created_at.strftime('%b %d, %Y')
          end
        end
      else
        para "No orders for this product yet"
      end
    end
  end

  # Ransack methods for search
  def self.ransackable_associations(auth_object = nil)
    ["category", "authors", "product_authors", "order_items"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "description", "isbn", "current_price", "stock_quantity", 
     "publisher", "pages", "language", "category_id", "publication_date", 
     "created_at", "updated_at", "on_sale"]
  end
end