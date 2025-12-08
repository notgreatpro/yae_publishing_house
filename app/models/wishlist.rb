class Wishlist < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  validates :customer_id, uniqueness: { scope: :product_id, message: "has already added this product to wishlist" }
  validate :product_must_be_available

  private

  def product_must_be_available
    if product && product.stock_quantity && product.stock_quantity <= 0
      errors.add(:product, "is not available")
    end
  end
end