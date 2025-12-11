class CreateEventRegistrations < ActiveRecord::Migration[8.0]
  def change
    create_table :event_registrations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.datetime :registered_at
      t.string :status

      t.timestamps
    end
  end
end
