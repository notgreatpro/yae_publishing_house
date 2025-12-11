# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: 'Yae Publishing House'
  layout 'mailer'
  
  # Confirmation email to applicant
  def confirmation_email(application)
    @application = application
    @job = application.job
    
    mail(
      to: @application.email,
      subject: "Application Received - #{@job.title} at Yae Publishing House"
    )
  end
  
  # Notification to admin/recruiter
  def new_application_notification(application)
    @application = application
    @job = application.job
    
    # Send to the job's contact email or a default recruitment email
    recipient = @job.contact_email.presence || 'recruitment@yaepublishinghouse.co.in'
    
    mail(
      to: recipient,
      subject: "New Application: #{@job.title} - #{@application.full_name}"
    )
  end
  
  # Status update email to applicant
  def status_update_email(application, old_status)
    @application = application
    @job = application.job
    @old_status = old_status
    @new_status = application.status
    
    mail(
      to: @application.email,
      subject: "Application Update - #{@job.title} at Yae Publishing House"
    )
  end
end