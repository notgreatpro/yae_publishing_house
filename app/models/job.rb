# app/models/job.rb
class Job < ApplicationRecord
  # Associations
  has_many :job_applications, dependent: :destroy
  
  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 200 }
  validates :department, presence: true
  validates :job_type, presence: true
  validates :location, presence: true
  validates :experience_level, presence: true
  validates :description, presence: true, length: { minimum: 50 }
  validates :responsibilities, presence: true
  validates :requirements, presence: true
  validates :contact_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  validates :salary_min, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :salary_max, numericality: { greater_than: :salary_min }, allow_nil: true, if: -> { salary_min.present? }
  
  # Enums - Fixed for Rails 7+
  enum :department, {
    editorial: 'editorial',
    design: 'design',
    marketing: 'marketing',
    sales: 'sales',
    operations: 'operations',
    technology: 'technology'
  }
  
  enum :job_type, {
    full_time: 'full_time',
    part_time: 'part_time',
    contract: 'contract',
    internship: 'internship'
  }
  
  enum :location, {
    inazuma: 'inazuma',
    remote: 'remote',
    hybrid: 'hybrid'
  }
  
  enum :experience_level, {
    entry: 'entry',
    mid: 'mid',
    senior: 'senior',
    lead: 'lead'
  }
  
  # Scopes
  scope :active_jobs, -> { where(active: true) }
  scope :featured_jobs, -> { where(featured: true) }
  scope :accepting_applications, -> { where(active: true).where('application_deadline IS NULL OR application_deadline > ?', Time.current) }
  scope :by_department, ->(dept) { where(department: dept) if dept.present? }
  scope :by_job_type, ->(type) { where(job_type: type) if type.present? }
  scope :by_location, ->(loc) { where(location: loc) if loc.present? }
  scope :by_experience, ->(exp) { where(experience_level: exp) if exp.present? }
  scope :recent, -> { order(created_at: :desc) }
  
  # Ransack configuration for ActiveAdmin
  def self.ransackable_associations(auth_object = nil)
    ["job_applications"]
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "title",
      "department",
      "job_type",
      "location",
      "experience_level",
      "description",
      "responsibilities",
      "requirements",
      "preferred_qualifications",
      "benefits",
      "salary_min",
      "salary_max",
      "application_deadline",
      "contact_email",
      "active",
      "featured",
      "created_at",
      "updated_at"
    ]
  end
  
  # Instance Methods
  def accepting_applications?
    active? && (application_deadline.nil? || application_deadline > Time.current)
  end
  
  def department_icon
    case department
    when 'editorial' then 'pen'
    when 'design' then 'palette'
    when 'marketing' then 'megaphone'
    when 'sales' then 'graph-up'
    when 'operations' then 'gear'
    when 'technology' then 'code-slash'
    else 'briefcase'
    end
  end
  
  def formatted_salary_range
    return 'Competitive' unless salary_min.present? && salary_max.present?
    "#{ActionController::Base.helpers.number_to_currency(salary_min)} - #{ActionController::Base.helpers.number_to_currency(salary_max)}"
  end
  
  def application_count
    job_applications.count
  end
  
  def days_since_posted
    ((Time.current - created_at) / 1.day).to_i
  end
  
  def self.filter_jobs(params)
    jobs = active_jobs.recent
    jobs = jobs.by_department(params[:department]) if params[:department].present?
    jobs = jobs.by_job_type(params[:job_type]) if params[:job_type].present?
    jobs = jobs.by_location(params[:location]) if params[:location].present?
    jobs = jobs.by_experience(params[:experience_level]) if params[:experience_level].present?
    jobs
  end
end