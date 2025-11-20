class ProductAuthor < ApplicationRecord
  belongs_to :product
  belongs_to :author
end
