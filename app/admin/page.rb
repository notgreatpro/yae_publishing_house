# app/admin/pages.rb
# Feature 1.4 - Edit content of website's contact and about page

ActiveAdmin.register Page do
  permit_params :title, :content, :slug

  # Customize index page
  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :updated_at
    actions
  end

  # Customize filter sidebar
  filter :title
  filter :slug
  filter :created_at
  filter :updated_at

  # Customize form
  form do |f|
    f.inputs 'Page Details' do
      f.input :title, 
              label: 'Page Title',
              hint: 'e.g., "About Us" or "Contact Us"'
      
      f.input :slug, 
              label: 'Page Slug',
              hint: 'URL-friendly identifier (e.g., "about" or "contact"). Do not change this after creation.',
              input_html: { placeholder: 'about' }
      
      f.input :content, 
              as: :text,
              label: 'Page Content',
              hint: 'Enter the full content for this page. You can use line breaks for paragraphs.',
              input_html: { rows: 20, style: 'font-family: monospace;' }
    end
    f.actions
  end

  # Customize show page
  show do
    attributes_table do
      row :id
      row :title
      row :slug
      row :content do |page|
        simple_format page.content
      end
      row :created_at
      row :updated_at
    end
  end
end