# app/models/event.rb
class Event < ApplicationRecord
  # Enums
  enum :event_type, {
    book_launch: 0,
    author_signing: 1,
    reading_session: 2,
    workshop: 3,
    book_club: 4,
    literary_festival: 5,
    panel_discussion: 6,
    other: 7
  }

  enum :status, {
    upcoming: 0,
    ongoing: 1,
    completed: 2,
    cancelled: 3
  }

  # Associations
  has_one_attached :cover_image
  has_many :event_registrations, dependent: :destroy
  has_many :customers, through: :event_registrations

  # Validations
  validates :title, presence: true, length: { maximum: 200 }
  validates :description, presence: true
  validates :event_type, presence: true
  validates :status, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :location, presence: true, length: { maximum: 300 }
  validates :max_attendees, numericality: { greater_than: 0 }, allow_nil: true
  validate :end_time_after_start_time
  validate :registration_deadline_before_start

  # Callbacks
  before_validation :set_defaults, on: :create
  after_initialize :set_defaults, if: :new_record?

  # Scopes
  scope :active, -> { where(active: true) }
  scope :upcoming, -> { where(status: :upcoming).where('starts_at > ?', Time.current) }
  scope :ongoing, -> { where(status: :ongoing).where('starts_at <= ? AND ends_at >= ?', Time.current, Time.current) }
  scope :past, -> { where('ends_at < ?', Time.current) }
  scope :featured, -> { where(featured: true) }
  scope :accepting_registrations, -> { 
    where('registration_deadline IS NULL OR registration_deadline > ?', Time.current)
    .where('max_attendees IS NULL OR current_attendees < max_attendees')
  }
  scope :by_start_date, -> { order(starts_at: :asc) }

  # Image variants
  def thumbnail_image
    cover_image.variant(resize_to_fill: [300, 200, { crop: :center }])
  end

  def medium_image
    cover_image.variant(resize_to_fill: [600, 400, { crop: :center }])
  end

  def large_image
    cover_image.variant(resize_to_fill: [1200, 800, { crop: :center }])
  end

  # Helper methods
  def formatted_date
    if starts_at.to_date == ends_at.to_date
      "#{starts_at.strftime('%B %d, %Y')}"
    else
      "#{starts_at.strftime('%B %d')} - #{ends_at.strftime('%B %d, %Y')}"
    end
  end

  def formatted_time
    "#{starts_at.strftime('%I:%M %p')} - #{ends_at.strftime('%I:%M %p')}"
  end

  def duration_in_hours
    ((ends_at - starts_at) / 3600.0).round(1)
  end

  def is_upcoming?
    starts_at > Time.current
  end

  def is_ongoing?
    starts_at <= Time.current && ends_at >= Time.current
  end

  def is_past?
    ends_at < Time.current
  end

  def spots_available
    return nil if max_attendees.nil?
    max_attendees - current_attendees
  end

  def is_full?
    return false if max_attendees.nil?
    current_attendees >= max_attendees
  end

  def can_register?
    return false unless active
    return false if is_full?
    return false if registration_deadline.present? && registration_deadline < Time.current
    return false if is_past?
    true
  end

  def registration_status_text
    return "Registration Closed" if !active || is_past?
    return "Registration Deadline Passed" if registration_deadline.present? && registration_deadline < Time.current
    return "Event Full" if is_full?
    return "Open for Registration"
  end

  def event_type_icon
    case event_type
    when 'book_launch'
      'rocket-takeoff-fill'
    when 'author_signing'
      'pen-fill'
    when 'reading_session'
      'book-fill'
    when 'workshop'
      'tools'
    when 'book_club'
      'people-fill'
    when 'literary_festival'
      'trophy-fill'
    when 'panel_discussion'
      'chat-dots-fill'
    else
      'calendar-event-fill'
    end
  end

  def status_badge_class
    case status
    when 'upcoming'
      'badge-upcoming'
    when 'ongoing'
      'badge-ongoing'
    when 'completed'
      'badge-completed'
    when 'cancelled'
      'badge-cancelled'
    end
  end

  # Ransack for ActiveAdmin search
  def self.ransackable_attributes(auth_object = nil)
    ["title", "description", "event_type", "status", "location", "starts_at", 
     "ends_at", "active", "featured", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def end_time_after_start_time
    return if starts_at.blank? || ends_at.blank?
    
    if ends_at <= starts_at
      errors.add(:ends_at, "must be after start time")
    end
  end

  def registration_deadline_before_start
    return if registration_deadline.blank? || starts_at.blank?
    
    if registration_deadline > starts_at
      errors.add(:registration_deadline, "must be before event start time")
    end
  end

  def set_defaults
    self.current_attendees ||= 0
    self.active = true if active.nil?
    self.featured = false if featured.nil?
    self.status ||= :upcoming
  end
end