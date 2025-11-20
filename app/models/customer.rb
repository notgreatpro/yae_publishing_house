class Customer < ApplicationRecord
  # Password encryption
  has_secure_password
  
  # Associations
  has_many :orders, dependent: :destroy
  
  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :phone, length: { maximum: 20 }, allow_blank: true
  validates :city, presence: true, length: { maximum: 100 }
  validates :country, presence: true, length: { maximum: 100 }
  validates :postal_code, presence: true, format: { with: /\A[A-Z]\d[A-Z] ?\d[A-Z]\d\z/i }, allow_blank: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end