class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications do |t|
      # Association (this automatically creates the index on job_id)
      t.references :job, null: false, foreign_key: true
      
      # Personal information
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :location, null: false
      
      # Professional information
      t.string :linkedin_url
      t.string :portfolio_url
      t.string :current_company
      t.string :years_experience, null: false
      
      # Application content
      t.text :why_interested, null: false
      t.string :availability, null: false
      t.decimal :salary_expectation, precision: 10, scale: 2
      t.text :additional_notes
      
      # Consent
      t.boolean :consent, null: false, default: false
      
      # Application status
      t.string :status, default: 'pending', null: false
      
      t.timestamps
    end
    
    # Indexes (removed duplicate job_id index)
    add_index :job_applications, :email
    add_index :job_applications, :status
    add_index :job_applications, :created_at
    add_index :job_applications, [:job_id, :email], unique: true, name: 'index_job_applications_on_job_and_email'
  end
end