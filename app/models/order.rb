class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :province, optional: true  # Made optional for international orders
  belongs_to :country, optional: true   # New: for international orders
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true
  validates :subtotal, :tax_amount, :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :address_line1, :city, :postal_code, presence: true
  
  # Validate that either province (for Canada) or country (for international) is present
  validate :must_have_province_or_country

  # Status options
  enum :status, {
    pending: 'pending',
    paid: 'paid',
    shipped: 'shipped',
    cancelled: 'cancelled'
  }, default: :pending

  # Calculate totals based on location (Canada or International)
  def calculate_totals
    self.subtotal = order_items.sum { |item| item.price_at_purchase * item.quantity }
    
    # Apply discount if present
    discount = discount_amount || 0
    subtotal_after_discount = subtotal - discount
    
    # Calculate taxes based on whether it's Canadian or international
    if is_canada? && province_id.present?
      calculate_canadian_taxes(subtotal_after_discount)
    elsif country_id.present?
      calculate_international_taxes(subtotal_after_discount)
    else
      # Fallback: no taxes
      self.gst_rate = 0
      self.pst_rate = 0
      self.hst_rate = 0
      self.tax_amount = 0
    end
    
    self.total_amount = subtotal_after_discount + tax_amount
  end

  def is_canada?
    is_canada == true || (country.present? && country.canada?)
  end

  def gst_amount
    return 0 if gst_rate.nil? || gst_rate == 0
    subtotal_after_discount = subtotal - (discount_amount || 0)
    ((subtotal_after_discount * gst_rate) / 100.0).round(2)
  end

  def pst_amount
    return 0 if pst_rate.nil? || pst_rate == 0
    subtotal_after_discount = subtotal - (discount_amount || 0)
    ((subtotal_after_discount * pst_rate) / 100.0).round(2)
  end

  def hst_amount
    return 0 if hst_rate.nil? || hst_rate == 0
    subtotal_after_discount = subtotal - (discount_amount || 0)
    ((subtotal_after_discount * hst_rate) / 100.0).round(2)
  end

  # After successful Stripe payment (Feature 3.3.1)
  def mark_as_paid!(stripe_payment_id, stripe_customer_id)
    update!(
      status: 'paid',
      stripe_payment_id: stripe_payment_id,
      stripe_customer_id: stripe_customer_id
    )
  end

  # Ransack methods for Active Admin search
  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items", "products", "province", "country"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "customer_id", "order_date", "total_amount", "order_status", 
     "payment_method", "shipping_address", "city", "country", "postal_code", 
     "shipped_date", "delivered_date", "created_at", "updated_at", "status", 
     "address_line1", "address_line2", "subtotal", "tax_amount", "gst_rate", 
     "pst_rate", "hst_rate", "province_id", "country_id", "is_canada",
     "stripe_payment_id", "stripe_customer_id", "discount_amount", "coupon_code"]
  end

  private

  def calculate_canadian_taxes(subtotal_after_discount)
    province_record = Province.find(province_id)
    self.gst_rate = province_record.gst_rate
    self.pst_rate = province_record.pst_rate
    self.hst_rate = province_record.hst_rate
    
    total_tax_rate = (gst_rate + pst_rate + hst_rate) / 100.0
    self.tax_amount = (subtotal_after_discount * total_tax_rate).round(2)
  end

  def calculate_international_taxes(subtotal_after_discount)
    country_record = Country.find(country_id)
    
    # For international orders, use the country's single tax rate
    self.gst_rate = country_record.tax_rate  # Store as GST for simplicity
    self.pst_rate = 0
    self.hst_rate = 0
    
    total_tax_rate = country_record.tax_rate / 100.0
    self.tax_amount = (subtotal_after_discount * total_tax_rate).round(2)
  end

  def must_have_province_or_country
    if is_canada && province_id.blank?
      errors.add(:province_id, "must be selected for Canadian addresses")
    elsif !is_canada && country_id.blank?
      errors.add(:country_id, "must be selected for international addresses")
    end
  end
end