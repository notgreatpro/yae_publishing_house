ActiveAdmin.register Category do
  menu priority: 4
  
  permit_params :category_name, :description

  index do
    selectable_column
    id_column
    column :category_name
    column :description
    column 'Books Count' do |category|
      category.products.count
    end
    column :created_at
    actions
  end

  filter :category_name
  filter :created_at

  form do |f|
    f.inputs 'Category Details' do
      f.input :category_name, label: "Category Name"
      f.input :description, as: :text, input_html: { rows: 4 }
    end
    f.actions
  end

  show do
    attributes_table do
      row :category_name
      row :description
      row :created_at
      row :updated_at
    end

    panel "Books in this Category" do
      if category.products.any?
        table_for category.products do
          column "Cover" do |product|
            if product.cover_image.attached?
              image_tag url_for(product.cover_image), size: "50x75"
            end
          end
          column "Title" do |product|
            link_to product.title, admin_product_path(product)
          end
          column "Authors" do |product|
            product.authors.map(&:author_name).join(", ")
          end
          column "Price" do |product|
            number_to_currency(product.current_price)
          end
          column "Stock", :stock_quantity
        end
      else
        para "No books in this category yet"
      end
    end
  end
end