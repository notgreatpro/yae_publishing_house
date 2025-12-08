# app/models/coupon.rb
class Coupon < ApplicationRecord
  # Discount categories
  DISCOUNT_CATEGORIES = %w[general bulk_discount flash_sale first_time_buyer].freeze
  
  # Validations
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :discount_type, presence: true, inclusion: { in: %w[percentage fixed] }
  validates :discount_value, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :usage_limit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :times_used, numericality: { greater_than_or_equal_to: 0 }
  validates :minimum_purchase, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :discount_category, inclusion: { in: DISCOUNT_CATEGORIES }, allow_nil: true
  validates :applies_to_quantity, numericality: { greater_than: 0 }, allow_nil: true
  
  # Callbacks
  before_validation :normalize_code
  after_initialize :set_defaults, if: :new_record?
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :not_expired, -> { where('expires_at IS NULL OR expires_at > ?', Time.current) }
  scope :available, -> { active.not_expired.where('usage_limit IS NULL OR times_used < usage_limit') }
  scope :flash_sales, -> { where(discount_category: 'flash_sale').where('flash_sale_ends_at > ?', Time.current) }
  scope :bulk_discounts, -> { where(discount_category: 'bulk_discount') }
  scope :first_time_buyer, -> { where(discount_category: 'first_time_buyer', first_time_buyer_only: true) }
  
  # Check if coupon is valid for use
  def valid_for_use?(cart_total = 0, customer = nil, cart_items = [])
    errors_list = []
    
    unless active?
      errors_list << "This coupon is not active"
    end
    
    if expires_at.present? && expires_at < Time.current
      errors_list << "This coupon has expired"
    end
    
    # Flash sale check
    if flash_sale? && flash_sale_ends_at.present? && flash_sale_ends_at < Time.current
      errors_list << "This flash sale has ended"
    end
    
    if usage_limit.present? && times_used >= usage_limit
      errors_list << "This coupon has reached its usage limit"
    end
    
    if minimum_purchase.present? && cart_total < minimum_purchase
      errors_list << "Minimum purchase of #{ActionController::Base.helpers.number_to_currency(minimum_purchase)} required"
    end
    
    # Bulk discount check
    if bulk_discount? && applies_to_quantity.present?
      total_quantity = cart_items.sum { |item| item[:quantity] }
      if total_quantity < applies_to_quantity
        errors_list << "You need at least #{applies_to_quantity} items to use this discount"
      end
    end
    
    # First-time buyer check
    if first_time_buyer? && customer
      if customer.orders.paid.any?
        errors_list << "This coupon is only for first-time buyers"
      end
    end
    
    errors_list.empty? ? true : errors_list
  end
  
  # Calculate discount amount
  def calculate_discount(cart_total)
    return 0 if cart_total <= 0
    
    case discount_type
    when 'percentage'
      (cart_total * discount_value / 100.0).round(2)
    when 'fixed'
      [discount_value, cart_total].min # Don't discount more than cart total
    else
      0
    end
  end
  
  # Increment usage count
  def increment_usage!
    increment!(:times_used)
  end
  
  # Display format
  def display_discount
    prefix = case discount_category
    when 'bulk_discount'
      applies_to_quantity.present? ? "Buy #{applies_to_quantity}+ get " : ""
    when 'flash_sale'
      "FLASH SALE: "
    when 'first_time_buyer'
      "NEW CUSTOMER: "
    else
      ""
    end
    
    discount_text = case discount_type
    when 'percentage'
      "#{discount_value}% off"
    when 'fixed'
      "#{ActionController::Base.helpers.number_to_currency(discount_value)} off"
    end
    
    "#{prefix}#{discount_text}"
  end
  
  # Helper methods for discount categories
  def bulk_discount?
    discount_category == 'bulk_discount'
  end
  
  def flash_sale?
    discount_category == 'flash_sale'
  end
  
  def first_time_buyer?
    discount_category == 'first_time_buyer' || first_time_buyer_only == true
  end
  
  # Time remaining for flash sale
  def time_remaining
    return nil unless flash_sale? && flash_sale_ends_at.present?
    
    diff = flash_sale_ends_at - Time.current
    return nil if diff <= 0
    
    hours = (diff / 3600).to_i
    minutes = ((diff % 3600) / 60).to_i
    seconds = (diff % 60).to_i
    
    if hours > 0
      "#{hours}h #{minutes}m"
    elsif minutes > 0
      "#{minutes}m #{seconds}s"
    else
      "#{seconds}s"
    end
  end
  
  # Ransack for ActiveAdmin search
  def self.ransackable_attributes(auth_object = nil)
    ["active", "code", "created_at", "discount_type", "discount_value", 
     "expires_at", "id", "minimum_purchase", "times_used", "updated_at", "usage_limit",
     "discount_category", "applies_to_quantity", "first_time_buyer_only", "flash_sale_ends_at"]
  end

  def self.ransackable_associations(auth_object = nil)
  []
end

  private
  
  def normalize_code
    self.code = code.upcase.strip if code.present?
  end
  
  def set_defaults
    self.times_used ||= 0
    self.active = true if active.nil?
  end
end