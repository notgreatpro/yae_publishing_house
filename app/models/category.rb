class Category < ApplicationRecord
  # Associations
  belongs_to :admin, foreign_key: 'created_by', optional: true
  has_many :products, dependent: :destroy
  
  # Validations
  validates :category_name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true

  # Ransack methods for Active Admin search
  def self.ransackable_associations(auth_object = nil)
    ["products", "admin"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "category_name", "description", "created_by", "created_at", "updated_at"]
  end
end