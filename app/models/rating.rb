# app/models/rating.rb
class Rating < ApplicationRecord
  belongs_to :product
  belongs_to :customer

  validates :score, presence: true, 
            inclusion: { in: 1..5, message: "must be between 1 and 5" }
  validates :customer_id, uniqueness: { scope: :product_id, 
            message: "can only rate a product once" }
  validates :review, length: { maximum: 1000 }, allow_blank: true

  after_save :update_product_rating
  after_destroy :update_product_rating

  # Ransack methods for Active Admin search
  def self.ransackable_associations(auth_object = nil)
    ["product", "customer"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "product_id", "customer_id", "score", "review", "created_at", "updated_at"]
  end

  private

  def update_product_rating
    product.update_rating_stats
  end
end