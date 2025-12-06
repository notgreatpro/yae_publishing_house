class MigratePagesToRichText < ActiveRecord::Migration[7.0]
  def up
    # Action Text will automatically handle rich text content
    # Just ensure old content column is removed if it exists as a text column
    
    # Migrate existing plain text content to rich text
    Page.find_each do |page|
      # Get the old plain text content
      old_content = page.read_attribute_before_type_cast(:content)
      
      if old_content.present? && old_content.is_a?(String)
        # Convert plain text paragraphs to HTML
        html_content = old_content.gsub(/\n\n+/, '</p><p>').prepend('<p>').concat('</p>')
        
        # Clear and save as rich text
        page.content = html_content
        page.save(validate: false)
      end
    end
    
    # Remove old content column if it exists
    if column_exists?(:pages, :content)
      remove_column :pages, :content
    end
  end
  
  def down
    # Add back the plain text column
    unless column_exists?(:pages, :content)
      add_column :pages, :content, :text
    end
    
    # Convert rich text back to plain text
    Page.find_each do |page|
      if page.content.present?
        plain_text = page.content.to_plain_text
        page.update_column(:content, plain_text)
      end
    end
  end
end