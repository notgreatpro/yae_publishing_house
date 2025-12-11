# app/controllers/careers_controller.rb
class CareersController < ApplicationController
  before_action :set_job, only: [:show]
  
  def index
    @jobs = Job.filter_jobs(filter_params)
    
    # Optional: Prioritize featured jobs
    @featured_jobs = @jobs.featured_jobs.limit(3)
    @regular_jobs = @jobs.where(featured: false)
    
    # For AJAX filtering
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def show
    unless @job.active?
      redirect_to careers_path, alert: 'This job posting is no longer active.'
    end
  end
  
  private
  
  def set_job
    @job = Job.find(params[:id])
  end
  
  def filter_params
    params.permit(:department, :job_type, :location, :experience_level)
  end
end