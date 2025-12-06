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

  # Load Trix editor assets
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

  # Form with enhanced Trix Editor and live preview
  form html: { multipart: true } do |f|
    # Add Trix CSS and JS to the form
    text_node <<-HTML.html_safe
      <link rel="stylesheet" type="text/css" href="https://unpkg.com/trix@2.0.0/dist/trix.css">
      <script type="text/javascript" src="https://unpkg.com/trix@2.0.0/dist/trix.umd.min.js"></script>
      <style>
        /* Trix Editor Styling */
        trix-toolbar .trix-button-group { margin-bottom: 10px; }
        trix-editor { 
          min-height: 500px; 
          border: 1px solid #c9d0d6; 
          border-radius: 4px; 
          padding: 20px;
          background: white;
          font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
          font-size: 15px;
          line-height: 1.6;
          transition: all 0.2s ease;
        }
        trix-editor:focus {
          border-color: #5e6469;
          outline: none;
          box-shadow: 0 0 0 3px rgba(94, 100, 105, 0.1);
        }
        
        /* Form Layout Enhancements */
        .rich_text.input { margin-bottom: 20px; }
        .rich_text.input label { 
          display: block; 
          margin-bottom: 8px;
          font-weight: 600;
          color: #3c3c3c;
          font-size: 14px;
        }
        .inline-hints { 
          color: #666; 
          font-size: 13px; 
          margin: 5px 0 12px 0;
          font-style: italic;
        }
        
        /* Stats Box */
        .stats-box {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          padding: 20px;
          border-radius: 8px;
          margin: 20px 0;
          box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .stats-box h3 {
          margin: 0 0 15px 0;
          font-size: 16px;
          font-weight: 600;
        }
        .stat-item {
          display: inline-block;
          margin-right: 25px;
          font-size: 14px;
        }
        .stat-item strong {
          font-size: 20px;
          display: block;
          margin-bottom: 3px;
        }
        
        /* Preview Toggle */
        .preview-toggle {
          background: #5e6469;
          color: white;
          border: none;
          padding: 10px 20px;
          border-radius: 4px;
          cursor: pointer;
          font-size: 14px;
          margin-bottom: 15px;
          transition: background 0.2s;
        }
        .preview-toggle:hover {
          background: #4a5056;
        }
        .preview-panel {
          display: none;
          background: #f9f9f9;
          border: 2px solid #e0e0e0;
          border-radius: 6px;
          padding: 25px;
          margin-bottom: 20px;
        }
        .preview-panel.active {
          display: block;
          animation: fadeIn 0.3s;
        }
        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(-10px); }
          to { opacity: 1; transform: translateY(0); }
        }
        
        /* Character counter */
        .char-counter {
          text-align: right;
          color: #666;
          font-size: 13px;
          margin-top: 5px;
        }
        
        /* Input enhancements */
        #page_title, #page_slug {
          font-size: 15px;
          padding: 10px;
          border-radius: 4px;
          border: 1px solid #c9d0d6;
          transition: border-color 0.2s;
        }
        #page_title:focus, #page_slug:focus {
          border-color: #5e6469;
          outline: none;
          box-shadow: 0 0 0 2px rgba(94, 100, 105, 0.1);
        }
      </style>
      
      <script>
        document.addEventListener('DOMContentLoaded', function() {
          // Auto-generate slug from title
          const titleInput = document.getElementById('page_title');
          const slugInput = document.getElementById('page_slug');
          
          if (titleInput && slugInput && !slugInput.value) {
            titleInput.addEventListener('input', function() {
              const slug = this.value
                .toLowerCase()
                .replace(/[^a-z0-9]+/g, '-')
                .replace(/^-|-$/g, '');
              slugInput.value = slug;
            });
          }
          
          // Character counter
          const editor = document.querySelector('trix-editor');
          if (editor) {
            const counterDiv = document.createElement('div');
            counterDiv.className = 'char-counter';
            editor.parentNode.appendChild(counterDiv);
            
            function updateCounter() {
              const text = editor.editor.getDocument().toString();
              const words = text.trim().split(/\\s+/).length;
              const chars = text.length;
              counterDiv.innerHTML = `<strong>${words}</strong> words | <strong>${chars}</strong> characters`;
            }
            
            editor.addEventListener('trix-change', updateCounter);
            updateCounter();
          }
          
          // Live preview toggle
          setTimeout(function() {
            const previewBtn = document.getElementById('preview-toggle');
            const previewPanel = document.getElementById('preview-panel');
            const editor = document.querySelector('trix-editor');
            
            if (previewBtn && previewPanel && editor) {
              previewBtn.addEventListener('click', function(e) {
                e.preventDefault();
                
                if (previewPanel.classList.contains('active')) {
                  previewPanel.classList.remove('active');
                  previewBtn.textContent = 'Toggle Live Preview';
                } else {
                  previewPanel.classList.add('active');
                  previewBtn.textContent = 'Hide Preview';
                  const content = editor.innerHTML;
                  previewPanel.innerHTML = '<h3 style="margin-top:0; color: #667eea;">Live Preview</h3><hr style="margin: 15px 0; border: none; border-top: 2px solid #667eea;">' + content;
                }
              });
              
              // Also update preview on content change when visible
              editor.addEventListener('trix-change', function() {
                if (previewPanel.classList.contains('active')) {
                  const content = editor.innerHTML;
                  previewPanel.innerHTML = '<h3 style="margin-top:0; color: #667eea;">Live Preview</h3><hr style="margin: 15px 0; border: none; border-top: 2px solid #667eea;">' + content;
                }
              });
            }
          }, 500);
        }
        });
      </script>
    HTML
    
    # Stats box for existing pages
    if f.object.persisted? && f.object.content.present?
      text_node <<-HTML.html_safe
        <div class="stats-box">
          <h3>Page Statistics</h3>
          <div class="stat-item">
            <strong>#{f.object.content.body.to_plain_text.split.size}</strong>
            <span>Words</span>
          </div>
          <div class="stat-item">
            <strong>#{f.object.content.body.to_plain_text.length}</strong>
            <span>Characters</span>
          </div>
          <div class="stat-item">
            <strong>#{time_ago_in_words(f.object.updated_at)} ago</strong>
            <span>Last Updated</span>
          </div>
        </div>
      HTML
    end
    
    f.inputs 'Page Details' do
      f.input :title, 
              label: 'Page Title',
              hint: 'e.g., "About Us" or "Privacy Policy"',
              input_html: { style: 'width: 100%; max-width: 600px;' }
      
      f.input :slug, 
              label: 'Page Slug',
              hint: 'URL-friendly identifier (auto-generated from title if left blank)',
              input_html: { style: 'width: 100%; max-width: 600px;' }
      
      if f.object.class.column_names.include?('published')
        f.input :published,
                label: 'Published',
                hint: 'Uncheck to save as draft'
      end
    end
    
    # Render Trix editor with preview
    f.inputs 'Page Content' do
      li class: 'rich_text input optional' do
        label 'Content', class: 'label'
        para 'Use the toolbar to format text: bold, italic, headings, lists, links', class: 'inline-hints'
        
        # Preview toggle button
        text_node <<-HTML.html_safe
          <button type="button" id="preview-toggle" class="preview-toggle">Toggle Live Preview</button>
          <div id="preview-panel" class="preview-panel"></div>
        HTML
        
        # Get existing content
        existing_content = ''
        if f.object.content.present? && f.object.content.body.present?
          existing_content = f.object.content.body.to_s
        end
        
        # Render Trix editor
        text_node <<-HTML.html_safe
          <input 
            id="page_content_trix_input" 
            type="hidden" 
            name="page[content]" 
            value="#{CGI.escapeHTML(existing_content)}"
          >
          <trix-editor 
            input="page_content_trix_input"
            class="trix-content"
            placeholder="Start typing your content here..."
          ></trix-editor>
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
            div style: 'padding: 15px;' do
              div style: 'margin-bottom: 15px;' do
                strong "Word Count: "
                span resource.content.body.to_plain_text.split.size, style: 'font-size: 24px; color: #667eea;'
              end
              div style: 'margin-bottom: 15px;' do
                strong "Characters: "
                span resource.content.body.to_plain_text.length, style: 'font-size: 24px; color: #764ba2;'
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
          div resource.content.body.to_s.html_safe, style: 'line-height: 1.8; color: #34495e;'
        else
          para 'No content to preview', style: 'color: #999; font-style: italic;'
        end
      end
    end
  end
end