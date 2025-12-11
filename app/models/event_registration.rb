class EventRegistration < ApplicationRecord
  belongs_to :event
  belongs_to :customer
  
  validates :customer_id, uniqueness: { scope: :event_id, message: "already registered for this event" }
  validates :status, inclusion: { in: %w[confirmed cancelled attended] }
  
  before_validation :set_default_status, on: :create
  after_create :increment_attendees
  after_destroy :decrement_attendees
  after_update :update_attendees_count, if: :saved_change_to_status?
  
  private
  
  def set_default_status
    self.status ||= 'confirmed'
  end
  
  def increment_attendees
    event.increment!(:current_attendees) if status == 'confirmed'
  end
  
  def decrement_attendees
    event.decrement!(:current_attendees) if status == 'confirmed'
  end
  
  def update_attendees_count
    if status == 'cancelled' && status_before_last_save == 'confirmed'
      event.decrement!(:current_attendees)
    elsif status == 'confirmed' && status_before_last_save == 'cancelled'
      event.increment!(:current_attendees)
    end
  end
end