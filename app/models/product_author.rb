class ProductAuthor < ApplicationRecord
  # Associations (Many-to-Many Junction Table)
  belongs_to :product
  belongs_to :author
  
  # Validations
  validates :product_id, uniqueness: { scope: :author_id, message: "Author already associated with this product" }
end