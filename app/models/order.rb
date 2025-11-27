class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :province
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true
  validates :subtotal, :tax_amount, :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :address_line1, :city, :postal_code, :province_id, presence: true

  # Status options
  enum status: {
    pending: 'pending',
    paid: 'paid',
    shipped: 'shipped',
    cancelled: 'cancelled'
  }

  # Calculate totals based on province tax rates
  def calculate_totals
    self.subtotal = order_items.sum { |item| item.price_at_purchase * item.quantity }
    
    # Get tax rates from province
    province_record = Province.find(province_id)
    self.gst_rate = province_record.gst_rate
    self.pst_rate = province_record.pst_rate
    self.hst_rate = province_record.hst_rate
    
    # Calculate tax
    total_tax_rate = (gst_rate + pst_rate + hst_rate) / 100.0
    self.tax_amount = (subtotal * total_tax_rate).round(2)
    self.total_amount = subtotal + tax_amount
  end

  def gst_amount
    ((subtotal * gst_rate) / 100.0).round(2) if gst_rate > 0
  end

  def pst_amount
    ((subtotal * pst_rate) / 100.0).round(2) if pst_rate > 0
  end

  def hst_amount
    ((subtotal * hst_rate) / 100.0).round(2) if hst_rate > 0
  end
end