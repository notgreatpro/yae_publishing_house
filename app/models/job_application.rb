# app/models/job_application.rb
class JobApplication < ApplicationRecord
  # Associations
  belongs_to :job
  
  # ActiveStorage attachments
  has_one_attached :resume
  has_one_attached :cover_letter
  
  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :location, presence: true
  validates :years_experience, presence: true
  validates :why_interested, presence: true, length: { minimum: 200, maximum: 2000 }
  validates :availability, presence: true
  validates :consent, acceptance: true
  
  validates :resume, presence: true
  validate :resume_format
  validate :cover_letter_format, if: -> { cover_letter.attached? }
  
  validates :linkedin_url, format: { with: URI::regexp(%w[http https]), allow_blank: true }
  validates :portfolio_url, format: { with: URI::regexp(%w[http https]), allow_blank: true }
  
  validates :salary_expectation, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  # Prevent duplicate applications from same email for same job
  validates :email, uniqueness: { scope: :job_id, message: "has already applied for this position" }
  
  # Enums - Fixed for Rails 7+
  enum :status, {
    pending: 'pending',
    under_review: 'under_review',
    interview: 'interview',
    rejected: 'rejected',
    accepted: 'accepted'
  }, default: :pending
  
  enum :years_experience, {
    zero_to_one: '0-1',
    one_to_two: '1-2',
    three_to_five: '3-5',
    five_to_ten: '5-10',
    ten_plus: '10+'
  }
  
  enum :availability, {
    immediate: 'immediate',
    two_weeks: '2-weeks',
    one_month: '1-month',
    two_three_months: '2-3-months',
    other: 'other'
  }
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :for_job, ->(job_id) { where(job_id: job_id) }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  
  # Ransack configuration for ActiveAdmin
  def self.ransackable_associations(auth_object = nil)
    ["job"]
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "first_name",
      "last_name",
      "email",
      "phone",
      "location",
      "linkedin_url",
      "portfolio_url",
      "current_company",
      "years_experience",
      "why_interested",
      "availability",
      "salary_expectation",
      "additional_notes",
      "consent",
      "status",
      "job_id",
      "created_at",
      "updated_at"
    ]
  end
  
  # Instance Methods
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def status_badge_class
    case status
    when 'pending' then 'warning'
    when 'under_review' then 'info'
    when 'interview' then 'primary'
    when 'rejected' then 'error'
    when 'accepted' then 'ok'
    else 'secondary'
    end
  end
  
  def formatted_availability
    case availability
    when 'immediate' then 'Immediately'
    when 'two_weeks' then 'Within 2 weeks'
    when 'one_month' then 'Within 1 month'
    when 'two_three_months' then 'Within 2-3 months'
    when 'other' then 'Other (see notes)'
    else availability.titleize
    end
  end
  
  private
  
  def resume_format
    return unless resume.attached?
    
    unless resume.content_type.in?(%w[application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document])
      errors.add(:resume, 'must be a PDF, DOC, or DOCX file')
    end
    
    if resume.byte_size > 5.megabytes
      errors.add(:resume, 'must be less than 5MB')
    end
  end
  
  def cover_letter_format
    return unless cover_letter.attached?
    
    unless cover_letter.content_type.in?(%w[application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document])
      errors.add(:cover_letter, 'must be a PDF, DOC, or DOCX file')
    end
    
    if cover_letter.byte_size > 5.megabytes
      errors.add(:cover_letter, 'must be less than 5MB')
    end
  end
end