class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :category_name
      t.text :description
     t.references :created_by, null: true, foreign_key: { to_table: :admins }

      t.timestamps
    end
  end
end
