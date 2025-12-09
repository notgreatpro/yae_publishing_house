# app/controllers/events_controller.rb
class EventsController < ApplicationController
  def index
    @events = Event.active.by_start_date
    
    # Filter by type
    if params[:event_type].present?
      @events = @events.where(event_type: params[:event_type])
    end
    
    # Filter by status/time
    case params[:filter]
    when 'upcoming'
      @events = @events.upcoming
    when 'ongoing'
      @events = @events.ongoing
    when 'past'
      @events = @events.past
    else
      @events = @events.where.not(status: :cancelled)
    end
    
    @events = @events.page(params[:page]).per(12)
    @featured_events = Event.active.featured.upcoming.limit(3)
  end

  def show
    @event = Event.find(params[:id])
  end
end