# app/models/page.rb
class Page < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }
  has_rich_text :content 

  # For Ransack (ActiveAdmin searching)
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "slug", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Helper method to find pages by slug
  def self.find_by_slug!(slug)
    find_by!(slug: slug)
  end
end