class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product
  
  # Validations
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price_at_purchase, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :subtotal, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  # Callback to calculate subtotal before validation (so it's available for validation)
  before_validation :calculate_subtotal
  
  private
  
  def calculate_subtotal
    self.subtotal = quantity * price_at_purchase if quantity.present? && price_at_purchase.present?
  end
end