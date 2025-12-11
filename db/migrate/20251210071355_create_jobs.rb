class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      # Basic information
      t.string :title, null: false
      t.string :department, null: false
      t.string :job_type, null: false
      t.string :location, null: false
      t.string :experience_level, null: false
      
      # Job details
      t.text :description, null: false
      t.text :responsibilities, null: false
      t.text :requirements, null: false
      t.text :preferred_qualifications
      t.text :benefits
      
      # Compensation
      t.decimal :salary_min, precision: 10, scale: 2
      t.decimal :salary_max, precision: 10, scale: 2
      
      # Application settings
      t.datetime :application_deadline
      t.string :contact_email, null: false
      
      # Status flags
      t.boolean :active, default: true, null: false
      t.boolean :featured, default: false, null: false
      
      t.timestamps
    end
    
    # Indexes for better query performance
    add_index :jobs, :department
    add_index :jobs, :job_type
    add_index :jobs, :location
    add_index :jobs, :experience_level
    add_index :jobs, :active
    add_index :jobs, :featured
    add_index :jobs, :created_at
  end
end