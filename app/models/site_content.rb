class SiteContent < ApplicationRecord
  # Associations
  belongs_to :admin, foreign_key: 'updated_by', optional: true
  
  # Validations
  validates :page_name, presence: true, uniqueness: true, inclusion: { in: %w[about contact] }
  validates :content, presence: true, length: { minimum: 10 }

  # Ransack methods for Active Admin search
  def self.ransackable_associations(auth_object = nil)
    ["admin"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "page_name", "content", "updated_by", "created_at", "updated_at"]
  end
end