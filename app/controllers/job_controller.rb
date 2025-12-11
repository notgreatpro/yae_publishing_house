# app/controllers/job_applications_controller.rb
class JobApplicationsController < ApplicationController
  before_action :set_job, only: [:new, :create]
  
  def new
    @application = JobApplication.new
    
    unless @job.accepting_applications?
      redirect_to career_path(@job), alert: 'This position is no longer accepting applications.'
    end
  end
  
  def create
    @application = @job.job_applications.new(application_params)
    
    if @application.save
      # Send confirmation email to applicant
      ApplicationMailer.confirmation_email(@application).deliver_later
      
      # Notify admin/recruiter
      ApplicationMailer.new_application_notification(@application).deliver_later
      
      redirect_to career_path(@job), notice: 'Your application has been submitted successfully! We\'ll be in touch soon.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_job
    @job = Job.find(params[:id] || params[:job_id])
  end
  
  def application_params
    params.require(:job_application).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :location,
      :linkedin_url,
      :portfolio_url,
      :current_company,
      :years_experience,
      :why_interested,
      :availability,
      :salary_expectation,
      :additional_notes,
      :consent,
      :resume,
      :cover_letter
    )
  end
end