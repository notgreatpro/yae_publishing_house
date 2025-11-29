class Author < ApplicationRecord
  # Associations
  belongs_to :admin, foreign_key: 'created_by', optional: true
  has_many :product_authors, dependent: :destroy
  has_many :products, through: :product_authors
  
  # Validations
  validates :author_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :biography, length: { maximum: 5000 }, allow_blank: true
  validates :nationality, length: { maximum: 100 }, allow_blank: true

  # Ransack methods for Active Admin search
  def self.ransackable_associations(auth_object = nil)
    ["product_authors", "products", "admin"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "author_name", "biography", "nationality", "created_by", "created_at", "updated_at"]
  end
end