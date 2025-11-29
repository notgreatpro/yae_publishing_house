class ProductAuthor < ApplicationRecord
  # Associations (Many-to-Many Junction Table)
  belongs_to :product
  belongs_to :author
  
  # Validations
  validates :product_id, uniqueness: { scope: :author_id, message: "Author already associated with this product" }

  # Ransack methods for Active Admin search (optional for join tables)
  def self.ransackable_associations(auth_object = nil)
    ["product", "author"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "product_id", "author_id", "created_at", "updated_at"]
  end
end