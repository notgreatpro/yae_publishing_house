class AddPublishedToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :published, :boolean, default: false, null: false
    
    # Set all existing pages to published by default
    reversible do |dir|
      dir.up do
        Page.update_all(published: true)
      end
    end
  end
end