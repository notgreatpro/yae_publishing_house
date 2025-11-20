class CreateSiteContents < ActiveRecord::Migration[8.0]
  def change
    create_table :site_contents do |t|
      t.string :page_name
      t.text :content
      t.references :updated_by, null: true, foreign_key: { to_table: :admins }

      t.timestamps
    end
  end
end
