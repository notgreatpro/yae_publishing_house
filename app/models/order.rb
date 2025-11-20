class Order < ApplicationRecord
  # Associations
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  
  # Validations
  validates :order_date, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :order_status, presence: true, inclusion: { in: %w[pending paid shipped delivered cancelled] }
  validates :payment_method, length: { maximum: 50 }, allow_blank: true
  validates :city, presence: true, length: { maximum: 100 }
  validates :country, presence: true, length: { maximum: 100 }
  validates :postal_code, presence: true
end