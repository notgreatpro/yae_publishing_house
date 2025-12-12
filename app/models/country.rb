class Country < ApplicationRecord
  has_many :orders
  has_many :customers
  
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true, length: { is: 2 }
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  
  scope :active, -> { where(active: true) }
  scope :canada, -> { find_by(code: 'CA') }
  scope :teyvat_nations, -> { where(code: ['MD', 'LY', 'IN', 'SM', 'FT', 'NT', 'SN', 'KH', 'NK']) }
  
  def canada?
    code == 'CA'
  end
  
  def teyvat_nation?
    ['MD', 'LY', 'IN', 'SM', 'FT', 'NT', 'SN', 'KH', 'NK'].include?(code)
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["name", "code", "tax_rate", "tax_name", "currency_code", "active", "created_at", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["orders", "customers"]
  end
end