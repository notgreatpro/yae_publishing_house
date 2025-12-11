# app/admin/job_applications.rb
ActiveAdmin.register JobApplication do
  menu priority: 7, label: "Job Applications"
  
  # Permit parameters
  permit_params :status
  
  # Filters
  filter :job, as: :select, collection: -> { Job.order(:title).pluck(:title, :id) }
  filter :status, as: :select, collection: JobApplication.statuses.keys
  filter :first_name
  filter :last_name
  filter :email
  filter :years_experience, as: :select, collection: JobApplication.years_experiences.keys
  filter :availability, as: :select, collection: JobApplication.availabilities.keys
  filter :created_at
  
  # Scopes
  scope :all, default: true
  scope :pending, -> { where(status: 'pending') }
  scope :under_review, -> { where(status: 'under_review') }
  scope :interview, -> { where(status: 'interview') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :rejected, -> { where(status: 'rejected') }
  
  # Index page
  index do
    selectable_column
    id_column
    
    column :applicant do |app|
      link_to app.full_name, admin_job_application_path(app)
    end
    
    column :email do |app|
      mail_to app.email
    end
    
    column :job do |app|
      link_to app.job.title, admin_job_path(app.job)
    end
    
    column :status do |app|
      status_tag app.status.titleize, class: app.status_badge_class
    end
    
    column :experience do |app|
      app.years_experience
    end
    
    column :availability do |app|
      app.formatted_availability
    end
    
    column :applied do |app|
      time_ago_in_words(app.created_at) + ' ago'
    end
    
    actions defaults: true do |app|
      item "Resume", rails_blob_path(app.resume, disposition: "attachment"), 
           class: "member_link", target: "_blank" if app.resume.attached?
    end
  end
  
  # Show page
  show do
    attributes_table do
      row :id
      row :job do |app|
        link_to app.job.title, admin_job_path(app.job)
      end
      row :status do |app|
        status_tag app.status.titleize, class: app.status_badge_class
      end
      row :created_at do |app|
        "#{app.created_at.strftime('%B %d, %Y at %I:%M %p')} (#{time_ago_in_words(app.created_at)} ago)"
      end
    end
    
    panel "Applicant Information" do
      attributes_table_for job_application do
        row :full_name
        row :email do |app|
          mail_to app.email
        end
        row :phone do |app|
          link_to app.phone, "tel:#{app.phone}"
        end
        row :location
        row :linkedin_url do |app|
          link_to "View LinkedIn Profile", app.linkedin_url, target: "_blank" if app.linkedin_url.present?
        end
        row :portfolio_url do |app|
          link_to "View Portfolio", app.portfolio_url, target: "_blank" if app.portfolio_url.present?
        end
        row :current_company
        row :years_experience
      end
    end
    
    panel "Application Materials" do
      div do
        if job_application.resume.attached?
          div style: "margin-bottom: 15px;" do
            strong "Resume: "
            link_to job_application.resume.filename, 
                    rails_blob_path(job_application.resume, disposition: "attachment"),
                    class: "button", target: "_blank"
          end
        end
        
        if job_application.cover_letter.attached?
          div do
            strong "Cover Letter: "
            link_to job_application.cover_letter.filename,
                    rails_blob_path(job_application.cover_letter, disposition: "attachment"),
                    class: "button", target: "_blank"
          end
        end
      end
    end
    
    panel "Why Interested" do
      div do
        simple_format job_application.why_interested
      end
    end
    
    panel "Additional Information" do
      attributes_table_for job_application do
        row :availability do |app|
          app.formatted_availability
        end
        row :salary_expectation do |app|
          number_to_currency(app.salary_expectation) if app.salary_expectation.present?
        end
        row :additional_notes do |app|
          simple_format(app.additional_notes) if app.additional_notes.present?
        end
        row :consent do |app|
          status_tag(app.consent? ? 'Provided' : 'Not Provided', class: (app.consent? ? 'ok' : 'error'))
        end
      end
    end
    
    panel "Update Status" do
      active_admin_form_for [:admin, job_application], url: admin_job_application_path(job_application), method: :patch do |f|
        f.inputs do
          f.input :status, as: :select, 
                  collection: JobApplication.statuses.keys.map { |k| [k.titleize, k] },
                  include_blank: false
        end
        f.actions do
          f.action :submit, label: "Update Status"
        end
      end
    end
    
    active_admin_comments
  end
  
  # Form (for status updates)
  form do |f|
    f.semantic_errors
    
    f.inputs 'Application Status' do
      f.input :status, as: :select, 
              collection: JobApplication.statuses.keys.map { |k| [k.titleize, k] },
              include_blank: false,
              hint: "Update the application status"
    end
    
    f.actions
  end
  
  # Sidebar
  sidebar "Applicant Summary", only: :show do
    attributes_table_for job_application do
      row :full_name
      row :email
      row :phone
      row :experience do
        job_application.years_experience
      end
    end
    
    div style: "margin-top: 20px;" do
      link_to "Email Applicant", "mailto:#{job_application.email}", 
              class: "button", style: "width: 100%; text-align: center;"
    end
  end
  
  # Batch actions
  batch_action :mark_under_review do |ids|
    JobApplication.where(id: ids).update_all(status: 'under_review')
    redirect_to collection_path, notice: "Applications marked as under review"
  end
  
  batch_action :mark_for_interview do |ids|
    JobApplication.where(id: ids).update_all(status: 'interview')
    redirect_to collection_path, notice: "Applications marked for interview"
  end
  
  batch_action :reject do |ids|
    JobApplication.where(id: ids).update_all(status: 'rejected')
    redirect_to collection_path, notice: "Applications rejected"
  end
  
  # Custom collection actions
  collection_action :export_csv do
    @applications = JobApplication.includes(:job).all
    
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Name', 'Email', 'Phone', 'Job Title', 'Status', 'Experience', 'Applied Date']
      
      @applications.each do |app|
        csv << [
          app.id,
          app.full_name,
          app.email,
          app.phone,
          app.job.title,
          app.status,
          app.years_experience,
          app.created_at.strftime('%Y-%m-%d')
        ]
      end
    end
    
    send_data csv_data, filename: "job_applications_#{Date.today}.csv"
  end
  
  action_item :export, only: :index do
    link_to 'Export CSV', export_csv_admin_job_applications_path
  end
  
  # Controller configuration
  controller do
    def update
      @job_application = JobApplication.find(params[:id])
      old_status = @job_application.status
      
      # Try to get params from different possible sources
      if params[:job_application].present?
        update_params = params.require(:job_application).permit(:status)
      elsif params[:status].present?
        update_params = { status: params[:status] }
      else
        # Fallback: check if permitted_params works
        update_params = permitted_params[:job_application] if permitted_params[:job_application].present?
      end
      
      if update_params.present? && @job_application.update(update_params)
        # Send status update email if status changed
        if old_status != @job_application.status
          ApplicationMailer.status_update_email(@job_application, old_status).deliver_later
        end
        
        redirect_to admin_job_application_path(@job_application), 
                    notice: "Application status updated successfully"
      else
        flash[:error] = "Failed to update status"
        redirect_to admin_job_application_path(@job_application)
      end
    end
  end
end