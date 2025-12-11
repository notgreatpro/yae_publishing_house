class CreateCountries < ActiveRecord::Migration[7.0]
  def change
    create_table :countries do |t|
      t.string :name, null: false
      t.string :code, null: false, limit: 2  # ISO 3166-1 alpha-2 code (US, UK, JP, etc.)
      t.decimal :tax_rate, precision: 5, scale: 2, default: 0.0
      t.string :tax_name  # VAT, GST, Sales Tax, etc.
      t.string :currency_code, limit: 3, default: 'CAD'
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :countries, :code, unique: true
    add_index :countries, :name
  end
end