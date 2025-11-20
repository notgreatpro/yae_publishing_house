class Product < ApplicationRecord
  belongs_to :category
  belongs_to :created_by
end
