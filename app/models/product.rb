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
end