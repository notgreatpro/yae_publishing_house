# app/admin/page.rb
ActiveAdmin.register Page do
  permit_params :title, :slug, :content, :published

  # Custom actions for bulk operations
  batch_action :publish do |ids|
    batch_action_collection.find(ids).each do |page|
      page.update(published: true)
    end
    redirect_to collection_path, notice: "Pages have been published!"
  end

  batch_action :unpublish do |ids|
    batch_action_collection.find(ids).each do |page|
      page.update(published: false)
    end
    redirect_to collection_path, notice: "Pages have been unpublished!"
  end

  # Load CKEditor assets
  controller do
    def edit
      @page_title = "Edit #{resource.title}"
    end
    
    def new
      @page_title = "New Page"
    end
    
    # Duplicate page action
    def duplicate
      original_page = Page.find(params[:id])
      new_page = original_page.dup
      new_page.title = "#{original_page.title} (Copy)"
      new_page.slug = "#{original_page.slug}-copy-#{Time.now.to_i}"
      new_page.content = original_page.content.body.to_s if original_page.content.present?
      
      if new_page.save
        redirect_to edit_admin_page_path(new_page), notice: "Page duplicated successfully!"
      else
        redirect_to admin_pages_path, alert: "Failed to duplicate page."
      end
    end
  end

  # Add upload route BEFORE the member_action
  collection_action :upload_image, method: :post do
    respond_to do |format|
      format.json do
        if params[:upload].present?
          uploaded_file = params[:upload]
          
          blob = ActiveStorage::Blob.create_and_upload!(
            io: uploaded_file.tempfile,
            filename: uploaded_file.original_filename,
            content_type: uploaded_file.content_type
          )
          
          render json: {
            url: rails_blob_url(blob, only_path: false)
          }, status: :ok
        else
          render json: { 
            error: { message: 'No file uploaded' } 
          }, status: :bad_request
        end
      end
    end
  rescue => e
    Rails.logger.error "Image upload failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { 
      error: { message: "Upload failed: #{e.message}" } 
    }, status: :unprocessable_entity
  end

  # Add duplicate action route
  member_action :duplicate, method: :post do
    redirect_to resource_path(resource)
  end

  # Enhanced index page with stats and better layout
  index do
    selectable_column
    id_column
    column :title do |page|
      link_to page.title, admin_page_path(page), style: 'font-weight: 600;'
    end
    column :slug do |page|
      span page.slug, style: 'font-family: monospace; background: #f0f0f0; padding: 2px 6px; border-radius: 3px;'
    end
    column "Status" do |page|
      if page.respond_to?(:published)
        if page.published
          span "Published", class: "status_tag ok"
        else
          span "Draft", class: "status_tag warning"
        end
      else
        span "Active", class: "status_tag ok"
      end
    end
    column "Word Count" do |page|
      if page.content.present? && page.content.body.present?
        word_count = page.content.body.to_plain_text.split.size
        span "#{word_count} words", style: 'color: #666;'
      else
        span "0 words", style: 'color: #999;'
      end
    end
    column :updated_at do |page|
      span time_ago_in_words(page.updated_at) + " ago", style: 'color: #666; font-size: 13px;'
    end
    actions defaults: true do |page|
      item "Duplicate", duplicate_admin_page_path(page), method: :post, 
           style: 'color: #5E6469;', 
           data: { confirm: 'Create a copy of this page?' }
    end
  end

  # Scope filters
  scope :all, default: true
  scope("Published") { |scope| scope.where(published: true) } rescue nil
  scope("Drafts") { |scope| scope.where(published: false) } rescue nil

  # Enhanced filters
  filter :title
  filter :slug
  filter :created_at
  filter :updated_at

  # FORM - Using CKEditor 5
  form html: { multipart: true } do |f|
    # Add CKEditor 5 assets
    text_node <<-HTML.html_safe
      <script src="https://cdn.ckeditor.com/ckeditor5/40.1.0/classic/ckeditor.js"></script>
      
      <style>
        .ck-editor__editable {
          min-height: 400px;
        }
        
        .ck-content img {
          max-width: 100%;
          height: auto;
        }
        
        .ckeditor-container {
          margin-bottom: 20px;
        }
        
        .ckeditor-label {
          display: block;
          font-weight: 600;
          margin-bottom: 0.5rem;
          font-size: 14px;
          color: #3c3c3c;
        }
        
        .ckeditor-hint {
          color: #666;
          font-size: 13px;
          margin: 5px 0 12px 0;
          font-style: italic;
        }
      </style>
    HTML
    
    f.inputs 'Page Details' do
      f.input :title, 
              label: 'Page Title',
              hint: 'e.g., "About Us" or "Privacy Policy"'
      
      f.input :slug, 
              label: 'Page Slug',
              hint: 'URL-friendly identifier (leave blank to auto-generate from title)'
      
      if f.object.class.column_names.include?('published')
        f.input :published,
                label: 'Published',
                hint: 'Uncheck to save as draft'
      end
    end
    
    f.inputs 'Page Content' do
      li class: 'input ckeditor-container' do
        label 'Content', class: 'ckeditor-label'
        para 'Use the toolbar to format text and upload images', class: 'ckeditor-hint'
        
        # Get existing content
        existing_content = ''
        if f.object.content.present? && f.object.content.body.present?
          existing_content = f.object.content.body.to_s
        end
        
        # Render textarea and CKEditor
        text_node <<-HTML.html_safe
          <textarea id="page_content_editor" name="page[content]" style="display:none;">#{CGI.escapeHTML(existing_content)}</textarea>
          
          <script>
            ClassicEditor
              .create(document.querySelector('#page_content_editor'), {
                toolbar: {
                  items: [
                    'heading', '|',
                    'bold', 'italic', 'link', '|',
                    'bulletedList', 'numberedList', '|',
                    'uploadImage', 'blockQuote', '|',
                    'undo', 'redo'
                  ]
                },
                image: {
                  toolbar: [
                    'imageTextAlternative', '|',
                    'imageStyle:inline',
                    'imageStyle:block',
                    'imageStyle:side', '|',
                    'toggleImageCaption', '|',
                    'linkImage'
                  ],
                  styles: [
                    'full',
                    'side',
                    'alignLeft',
                    'alignCenter',
                    'alignRight'
                  ]
                },
                heading: {
                  options: [
                    { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
                    { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
                    { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
                    { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' }
                  ]
                }
              })
              .then(editor => {
                // Custom upload adapter
                editor.plugins.get('FileRepository').createUploadAdapter = (loader) => {
                  return {
                    upload: () => {
                      return loader.file.then(file => new Promise((resolve, reject) => {
                        const formData = new FormData();
                        formData.append('upload', file);

                        fetch('/admin/pages/upload_image', {
                          method: 'POST',
                          headers: {
                            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                          },
                          body: formData
                        })
                        .then(response => response.json())
                        .then(data => {
                          if (data.url) {
                            resolve({ default: data.url });
                          } else {
                            reject(data.error.message);
                          }
                        })
                        .catch(error => {
                          reject('Upload failed: ' + error);
                        });
                      }));
                    }
                  };
                };
              })
              .catch(error => {
                console.error('CKEditor initialization error:', error);
              });
          </script>
        HTML
      end
    end
    
    f.actions
  end

  # Enhanced show page with better preview
  show do
    columns do
      column span: 2 do
        panel "Page Details" do
          attributes_table do
            row :id
            row :title
            row :slug
            row :status do |p|
              if p.published
                span "Published", class: "status_tag ok"
              else
                span "Draft", class: "status_tag warning"
              end
            end
            row :created_at
            row :updated_at
          end
        end
      end
      
      column span: 1 do
        panel "Statistics" do
          if resource.content.present? && resource.content.body.present?
            # Count images in HTML
            html_content = resource.content.body.to_s
            image_count = html_content.scan(/<img/).length
            
            div style: 'padding: 15px;' do
              div style: 'margin-bottom: 15px;' do
                strong "Word Count: "
                span resource.content.body.to_plain_text.split.size, style: 'font-size: 24px; color: #667eea;'
              end
              div style: 'margin-bottom: 15px;' do
                strong "Characters: "
                span resource.content.body.to_plain_text.length, style: 'font-size: 24px; color: #764ba2;'
              end
              div style: 'margin-bottom: 15px;' do
                strong "Images: "
                span image_count, style: 'font-size: 24px; color: #f59e0b;'
              end
              div do
                strong "Last Updated: "
                span time_ago_in_words(resource.updated_at) + " ago", style: 'color: #666;'
              end
            end
          else
            para "No content yet", style: 'color: #999; font-style: italic; padding: 15px;'
          end
        end
        
        panel "Quick Actions" do
          div style: 'padding: 15px;' do
            div style: 'margin-bottom: 10px;' do
              link_to "Edit Page", edit_admin_page_path(resource), 
                      style: 'display: inline-block; padding: 8px 16px; background: #5e6469; color: white; text-decoration: none; border-radius: 4px; margin-right: 10px;'
            end
            div style: 'margin-bottom: 10px;' do
              link_to "Duplicate", duplicate_admin_page_path(resource), 
                      method: :post,
                      data: { confirm: 'Create a copy of this page?' },
                      style: 'display: inline-block; padding: 8px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 4px;'
            end
          end
        end
      end
    end
    
    panel "Content Preview" do
      div style: 'padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);' do
        h1 resource.title, style: 'margin-top: 0; color: #2c3e50; border-bottom: 3px solid #667eea; padding-bottom: 15px;'
        if resource.content.present? && resource.content.body.present?
          div class: 'content-preview' do
            # Add style to ensure images display properly
            text_node <<-HTML.html_safe
              <style>
                .content-preview img {
                  max-width: 100%;
                  height: auto;
                  display: block;
                  margin: 20px 0;
                  border-radius: 8px;
                  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                }
              </style>
            HTML
            div resource.content.body.to_s.html_safe, style: 'line-height: 1.8; color: #34495e;'
          end
        else
          para 'No content to preview', style: 'color: #999; font-style: italic;'
        end
      end
    end
  end
end