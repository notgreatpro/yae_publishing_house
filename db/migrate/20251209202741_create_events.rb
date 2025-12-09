class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :event_type, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.string :location, null: false
      t.string :venue_name
      t.integer :max_attendees
      t.integer :current_attendees, default: 0
      t.datetime :registration_deadline
      t.boolean :active, default: true
      t.boolean :featured, default: false
      t.text :organizer_info
      t.decimal :ticket_price, precision: 10, scale: 2
      t.string :contact_email
      t.string :contact_phone

      t.timestamps
    end

    add_index :events, :event_type
    add_index :events, :status
    add_index :events, :starts_at
    add_index :events, :active
    add_index :events, :featured
  end
end