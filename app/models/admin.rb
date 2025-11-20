class Admin < ApplicationRecord
  # Password encryption
  has_secure_password
  
  # Associations
  has_many :site_contents, foreign_key: 'updated_by'
  has_many :products, foreign_key: 'created_by'
  has_many :categories, foreign_key: 'created_by'
  has_many :authors, foreign_key: 'created_by'
  
  # Validations
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true
  validates :role, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end