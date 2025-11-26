class Customer < ApplicationRecord
  # Devise handles authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Associations
  has_many :orders, dependent: :destroy
  
  # Validations
  # Basic info required for signup
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :phone, length: { maximum: 20 }, allow_blank: true
  
  # Address fields are OPTIONAL (users can add during checkout)
  validates :city, length: { maximum: 100 }, allow_blank: true
  validates :country, length: { maximum: 100 }, allow_blank: true
  validates :postal_code, format: { with: /\A[\w\- ]+\z/ }, allow_blank: true
  
  # Helper method to get full name
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  # Check if customer has complete address
  def has_complete_address?
    city.present? && country.present? && postal_code.present? && address_line_1.present?
  end
end