# app/models/customer.rb
class Customer < ApplicationRecord
  # Devise handles authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one_attached :profile_picture
  
  # Associations
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  belongs_to :province, optional: true  # Made optional for international customers
  belongs_to :country, optional: true   # New: for international customers
  has_many :wishlists, dependent: :destroy
  has_many :wishlist_products, through: :wishlists, source: :product  

  # Validations
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  
  # Address fields are optional - only validate format if present
  validates :address_line1, length: { maximum: 255 }, allow_blank: true
  validates :address_line2, length: { maximum: 255 }, allow_blank: true
  validates :city, length: { maximum: 100 }, allow_blank: true
  validates :postal_code, length: { maximum: 50 }, allow_blank: true  # Increased for international codes
  validates :phone, length: { maximum: 20 }, allow_blank: true
  
  # Helper method to get full name
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  def initials
    "#{first_name[0]}#{last_name[0]}".upcase
  end
  
  # Check if customer has complete address (for checkout validation)
  def has_complete_address?
    if is_canada?
      address_line1.present? && city.present? && postal_code.present? && province_id.present?
    else
      address_line1.present? && city.present? && postal_code.present? && country_id.present?
    end
  end
  
  # Check if this is a Canadian address
  def is_canada?
    is_canada == true || (country.present? && country.canada?)
  end
  
  # Check if product is in wishlist
  def has_in_wishlist?(product)
    wishlist_products.include?(product)
  end

  # Ransack methods for Active Admin search
  def self.ransackable_associations(auth_object = nil)
    ["orders", "province", "country", "ratings"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "first_name", "last_name", "address_line1", "address_line2", 
     "city", "postal_code", "province_id", "country_id", "is_canada", "created_at", "updated_at"]
  end
end