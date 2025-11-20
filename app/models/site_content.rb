class SiteContent < ApplicationRecord
  # Associations
  belongs_to :admin, foreign_key: 'updated_by', optional: true
  
  # Validations
  validates :page_name, presence: true, uniqueness: true, inclusion: { in: %w[about contact] }
  validates :content, presence: true, length: { minimum: 10 }
end