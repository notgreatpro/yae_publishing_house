class Province < ApplicationRecord
  # Associations
  has_many :customers
  has_many :orders

  # Validations (add these if they don't exist)
  validates :name, presence: true
  validates :province_code, presence: true, uniqueness: true

  # Ransack methods for Active Admin search
  def self.ransackable_associations(auth_object = nil)
    ["customers", "orders"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "province_code", "gst_rate", "pst_rate", "hst_rate", 
     "created_at", "updated_at"]
  end
end