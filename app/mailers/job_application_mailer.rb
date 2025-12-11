# app/mailers/job_application_mailer.rb
class JobApplicationMailer < ApplicationMailer
  default from: 'careers@yaepublishing.co.in'
  
  def confirmation_email(application)
    @application = application
    @job = application.job
    
    mail(
      to: @application.email,
      subject: "Application Received - #{@job.title}"
    )
  end
  
  def new_application_notification(application)
    @application = application
    @job = application.job
    
    mail(
      to: @job.contact_email,
      subject: "New Application: #{@job.title} - #{@application.full_name}"
    )
  end
  
  def status_update_email(application, old_status)
    @application = application
    @job = application.job
    @old_status = old_status
    
    mail(
      to: @application.email,
      subject: "Application Update - #{@job.title}"
    )
  end
end