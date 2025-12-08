class Wishlist < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  validates :customer_id, uniqueness: { scope: :product_id, message: "has already added this product to wishlist" }
  validate :product_must_be_active

  private

  def product_must_be_active
    if product && !product.active
      errors.add(:product, "is not available")
    end
  end
end