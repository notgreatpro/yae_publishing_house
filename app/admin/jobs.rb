# app/admin/jobs.rb
ActiveAdmin.register Job do
  menu priority: 6, label: "Jobs"
  
  permit_params :title, :department, :job_type, :location, :experience_level,
                :description, :responsibilities, :requirements, :preferred_qualifications,
                :benefits, :salary_min, :salary_max, :application_deadline, :contact_email,
                :status, :featured
  
  index do
    selectable_column
    id_column
    column :title
    column :department
    column :job_type
    column :location
    column :status
    column :featured
    column :created_at
    actions
  end
  
  show do
    attributes_table do
      row :title
      row :department
      row :job_type
      row :location
      row :experience_level
      row :status
      row :featured
      row :salary_min
      row :salary_max
      row :application_deadline
      row :contact_email
      row :created_at
      row :updated_at
    end
    
    panel "Description" do
      div do
        simple_format job.description
      end
    end
    
    panel "Responsibilities" do
      div do
        simple_format job.responsibilities
      end
    end
    
    panel "Requirements" do
      div do
        simple_format job.requirements
      end
    end
    
    active_admin_comments
  end
  
  form do |f|
    f.semantic_errors
    
    f.inputs 'Job Details' do
      f.input :title
      f.input :department, as: :select, collection: Job.departments.keys
      f.input :job_type, as: :select, collection: Job.job_types.keys
      f.input :location, as: :select, collection: Job.locations.keys
      f.input :experience_level, as: :select, collection: Job.experience_levels.keys
      f.input :active, as: :boolean, label: 'Active'
      f.input :featured
    end
    
    f.inputs 'Job Content' do
      f.input :description, as: :text, input_html: { rows: 6 }
      f.input :responsibilities, as: :text, input_html: { rows: 6 }
      f.input :requirements, as: :text, input_html: { rows: 6 }
      f.input :preferred_qualifications, as: :text, input_html: { rows: 4 }
      f.input :benefits, as: :text, input_html: { rows: 4 }
    end
    
    f.inputs 'Salary & Contact' do
    f.input :salary_min, min: 0
    f.input :salary_max, min: 0
    f.input :application_deadline, as: :datepicker
    f.input :contact_email
    end
        
    f.actions
  end
end