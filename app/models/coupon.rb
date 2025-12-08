# app/models/coupon.rb
class Coupon < ApplicationRecord
  # Validations
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :discount_type, presence: true, inclusion: { in: %w[percentage fixed] }
  validates :discount_value, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :usage_limit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :times_used, numericality: { greater_than_or_equal_to: 0 }
  validates :minimum_purchase, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  # Callbacks
  before_validation :normalize_code
  after_initialize :set_defaults, if: :new_record?
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :not_expired, -> { where('expires_at IS NULL OR expires_at > ?', Time.current) }
  scope :available, -> { active.not_expired.where('usage_limit IS NULL OR times_used < usage_limit') }
  
  # Check if coupon is valid for use
  def valid_for_use?(cart_total = 0)
    errors_list = []
    
    unless active?
      errors_list << "This coupon is not active"
    end
    
    if expires_at.present? && expires_at < Time.current
      errors_list << "This coupon has expired"
    end
    
    if usage_limit.present? && times_used >= usage_limit
      errors_list << "This coupon has reached its usage limit"
    end
    
    if minimum_purchase.present? && cart_total < minimum_purchase
      errors_list << "Minimum purchase of #{ActionController::Base.helpers.number_to_currency(minimum_purchase)} required"
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
    case discount_type
    when 'percentage'
      "#{discount_value}% off"
    when 'fixed'
      "#{ActionController::Base.helpers.number_to_currency(discount_value)} off"
    end
  end
  
  # Ransack for ActiveAdmin search
  def self.ransackable_attributes(auth_object = nil)
    ["active", "code", "created_at", "discount_type", "discount_value", 
     "expires_at", "id", "minimum_purchase", "times_used", "updated_at", "usage_limit"]
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