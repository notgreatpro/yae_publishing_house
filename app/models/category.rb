class Category < ApplicationRecord
  # Associations
  belongs_to :admin, foreign_key: 'created_by', optional: true
  has_many :products, dependent: :destroy
  
  # Validations
  validates :category_name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
end