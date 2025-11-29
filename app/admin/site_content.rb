ActiveAdmin.register SiteContent do
  permit_params :title, :content, :slug

  # Only show About and Contact pages
  controller do
    def scoped_collection
      super.where(slug: ['about', 'contact'])
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :updated_at
    actions defaults: false do |page|
      item 'Edit', edit_admin_site_content_path(page)
    end
  end

  form do |f|
    f.inputs 'Page Content' do
      f.input :title
      f.input :slug, input_html: { disabled: true }
      f.input :content, as: :text, input_html: { rows: 10 }
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content do |page|
        simple_format(page.content)
      end
      row :updated_at
    end
  end
end