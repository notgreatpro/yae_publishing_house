class EventsController < ApplicationController
  before_action :authenticate_customer!, only: [:register, :unregister]
  
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
    @is_registered = @event.registered?(current_customer) if customer_signed_in?
  end
  
  def register
    @event = Event.find(params[:id])
    
    # Check if event allows registration
    unless @event.can_register?
      redirect_to event_path(@event), alert: @event.registration_status_text
      return
    end
    
    # Check if already registered
    if @event.registered?(current_customer)
      redirect_to event_path(@event), alert: "You are already registered for this event."
      return
    end
    
    # Create registration
    registration = @event.event_registrations.build(
      customer: current_customer,
      registered_at: Time.current,
      status: 'confirmed'
    )
    
    if registration.save
      redirect_to event_path(@event), notice: "Successfully registered for #{@event.title}!"
    else
      redirect_to event_path(@event), alert: "Failed to register. Please try again."
    end
  end
  
  def unregister
    @event = Event.find(params[:id])
    registration = @event.event_registrations.find_by(customer: current_customer, status: ['confirmed', 'attended'])
    
    if registration
      registration.update(status: 'cancelled')
      redirect_to event_path(@event), notice: "You have been unregistered from this event."
    else
      redirect_to event_path(@event), alert: "You are not registered for this event."
    end
  end
end