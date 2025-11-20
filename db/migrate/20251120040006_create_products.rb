class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :isbn
      t.text :description
      t.decimal :current_price
      t.integer :stock_quantity
      t.references :category, null: false, foreign_key: true
      t.string :publisher
      t.date :publication_date
      t.integer :pages
      t.string :language
      t.string :cover_image_url
      t.references :created_by, null: true, foreign_key: { to_table: :admins }

      t.timestamps
    end
  end
end
