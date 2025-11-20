class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :author_name
      t.text :biography
      t.string :nationality
      t.references :created_by, null: true, foreign_key: { to_table: :admins }

      t.timestamps
    end
  end
end
