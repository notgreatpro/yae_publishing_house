ActiveAdmin.register Author do
  menu priority: 3
  
  permit_params :author_name, :biography, :nationality

  index do
    selectable_column
    id_column
    column :author_name
    column :nationality
    column "Books Count" do |author|
      author.products.count
    end
    column :created_at
    actions
  end

  filter :author_name
  filter :nationality
  filter :created_at

  form do |f|
    f.inputs 'Author Information' do
      f.input :author_name, label: "Full Name"
      f.input :nationality
      f.input :biography, as: :text, input_html: { rows: 8 }
    end
    f.actions
  end

  show do
    attributes_table do
      row :author_name
      row :nationality
      row :biography do |author|
        simple_format(author.biography)
      end
      row :created_at
      row :updated_at
    end

    panel "Books by this Author" do
      if author.products.any?
        table_for author.products do
          column "Cover" do |product|
            if product.cover_image.attached?
              image_tag url_for(product.cover_image), size: "50x75"
            end
          end
          column "Title" do |product|
            link_to product.title, admin_product_path(product)
          end
          column "ISBN", :isbn
          column "Price" do |product|
            number_to_currency(product.current_price)
          end
          column "Stock", :stock_quantity
        end
      else
        para "No books by this author yet"
      end
    end
  end
end