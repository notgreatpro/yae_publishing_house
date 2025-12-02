class Product < ApplicationRecord
  # Active Storage - Add this line
  has_one_attached :cover_image
  
  # Associations
  belongs_to :category
  belongs_to :admin, foreign_key: 'created_by_id', optional: true
  has_many :product_authors, dependent: :destroy
  has_many :authors, through: :product_authors
  has_many :order_items, dependent: :destroy
  
  # Validations
  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  validates :isbn, uniqueness: true, allow_blank: true, length: { maximum: 20 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :current_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :publisher, length: { maximum: 255 }, allow_blank: true
  validates :pages, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
  validates :language, length: { maximum: 50 }, allow_blank: true

  # Ransack methods for Active Admin search
  def self.ransackable_associations(auth_object = nil)
    ["category", "authors", "product_authors", "order_items", "admin"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "isbn", "description", "current_price", "stock_quantity", 
     "publisher", "pages", "language", "category_id", "created_by_id", 
     "created_at", "updated_at"]
  end
   # Add these variant methods
  def thumbnail
    cover_image.variant(resize_to_limit: [100, 150]) if cover_image.attached?
  end
  
  def medium_image
    cover_image.variant(resize_to_limit: [300, 400]) if cover_image.attached?
  end
  
  def large_image
    cover_image.variant(resize_to_limit: [600, 800]) if cover_image.attached?
  end
end