class Customer < ApplicationRecord
  # Devise handles authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Associations
  has_many :orders, dependent: :destroy
  belongs_to :province, optional: true
  
  # Validations
  # Basic info required for signup
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  
  # Address fields are OPTIONAL (users can add during checkout or signup)
  validates :address_line1, presence: true, if: :address_present?
  validates :city, presence: true, if: :address_present?
  validates :postal_code, presence: true, format: { with: /\A[A-Z]\d[A-Z] ?\d[A-Z]\d\z/i }, if: :address_present?
  validates :province_id, presence: true, if: :address_present?
  
  validates :address_line2, length: { maximum: 255 }, allow_blank: true
  
  # Helper method to get full name
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  # Check if customer has complete address
  def has_complete_address?
    address_line1.present? && city.present? && postal_code.present? && province_id.present?
  end

  # Ransack methods for Active Admin search
  def self.ransackable_associations(auth_object = nil)
    ["orders", "province"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "first_name", "last_name", "address_line1", "address_line2", 
     "city", "postal_code", "province_id", "created_at", "updated_at"]
  end

  private

  def address_present?
    address_line1.present? || city.present? || postal_code.present? || province_id.present?
  end
end