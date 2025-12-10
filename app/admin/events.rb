# app/admin/events.rb
ActiveAdmin.register Event do
  permit_params :title, :description, :event_type, :status, :starts_at, :ends_at,
                :location, :venue_name, :max_attendees, :registration_deadline,
                :active, :featured, :organizer_info, :ticket_price,
                :contact_email, :contact_phone, :cover_image

  index do
    selectable_column
    id_column
    column :title
    column :event_type do |event|
      status_tag event.event_type.titleize, class: "event-type-#{event.event_type}"
    end
    column :status do |event|
      status_tag event.status.upcase, class: "status-#{event.status}"
    end
    column :starts_at
    column :ends_at
    column :location, sortable: false do |event|
      truncate(event.location, length: 30)
    end
    column :current_attendees
    column :max_attendees
    column :featured
    column :active
    actions
  end

  filter :title
  filter :event_type, as: :select, collection: Event.event_types.keys.map { |k| [k.titleize, k] }
  filter :status, as: :select, collection: Event.statuses.keys.map { |k| [k.titleize, k] }
  filter :starts_at
  filter :ends_at
  filter :location
  filter :active
  filter :featured
  filter :created_at

  form do |f|
    f.semantic_errors
    
    f.inputs 'Basic Information' do
      f.input :title, hint: 'Event name (e.g., "Jane Austen Book Launch")'
      f.input :description, as: :text, input_html: { rows: 8 }, 
              hint: 'Detailed description of the event'
      f.input :event_type, as: :select, collection: Event.event_types.keys.map { |k| [k.titleize, k] }
      f.input :status, as: :select, collection: Event.statuses.keys.map { |k| [k.titleize, k] }
      
      if f.object.new_record?
        f.input :cover_image, as: :file, hint: 'Upload event cover image'
      else
        f.input :cover_image, as: :file, hint: f.object.cover_image.attached? ? image_tag(f.object.cover_image.variant(resize_to_limit: [200, 200])) : 'Upload event cover image'
      end
    end

    f.inputs 'Date & Time' do
      f.input :starts_at, as: :datepicker, hint: 'When the event starts'
      f.input :ends_at, as: :datepicker, hint: 'When the event ends'
      f.input :registration_deadline, as: :datepicker, 
              hint: 'Last date to register (optional, leave blank for no deadline)'
    end

    f.inputs 'Location Details' do
      f.input :location, hint: 'Full address or location description'
      f.input :venue_name, hint: 'Name of the venue (optional)'
    end

    f.inputs 'Registration & Capacity' do
      f.input :max_attendees, hint: 'Maximum number of attendees (leave blank for unlimited)'
      f.input :ticket_price, hint: 'Ticket price (enter 0 for free events)'
    end

    f.inputs 'Organizer & Contact' do
      f.input :organizer_info, as: :text, input_html: { rows: 4 },
              hint: 'Information about the organizer'
      f.input :contact_email, hint: 'Contact email for inquiries'
      f.input :contact_phone, hint: 'Contact phone number'
    end

    f.inputs 'Settings' do
      f.input :active, hint: 'Event is visible on the website'
      f.input :featured, hint: 'Show in featured events section'
    end

    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description do |event|
        simple_format(event.description)
      end
      row :event_type do |event|
        status_tag event.event_type.titleize, class: "event-type-#{event.event_type}"
      end
      row :status do |event|
        status_tag event.status.upcase, class: "status-#{event.status}"
      end
      
      row :cover_image do |event|
        if event.cover_image.attached?
          image_tag event.cover_image.variant(resize_to_limit: [400, 300])
        else
          'No image'
        end
      end
      
      row :starts_at
      row :ends_at
      row :duration do |event|
        "#{event.duration_in_hours} hours"
      end
      
      row :location
      row :venue_name
      
      row :max_attendees
      row :current_attendees
      row :spots_available do |event|
        event.spots_available || 'Unlimited'
      end
      row :registration_deadline
      
      row :ticket_price do |event|
        if event.ticket_price.present?
          event.ticket_price > 0 ? number_to_currency(event.ticket_price) : 'FREE'
        else
          'Not set'
        end
      end
      
      row :organizer_info do |event|
        simple_format(event.organizer_info) if event.organizer_info.present?
      end
      
      row :contact_email
      row :contact_phone
      
      row :active
      row :featured
      
      row :registration_status do |event|
        status_tag event.registration_status_text
      end
      
      row :created_at
      row :updated_at
    end

    panel "Quick Actions" do
      div do
        link_to "View on Website", event_path(event), class: "button", target: "_blank"
      end
    end
  end

  # Custom actions
  action_item :update_status, only: :show do
    dropdown_menu "Update Status" do
      Event.statuses.keys.each do |status|
        item status.titleize, update_status_admin_event_path(event, status: status), method: :put unless event.status == status
      end
    end
  end

  member_action :update_status, method: :put do
    resource.update(status: params[:status])
    redirect_to admin_event_path(resource), notice: "Event status updated to #{params[:status].titleize}"
  end

  # Batch actions
  batch_action :activate do |ids|
    Event.where(id: ids).update_all(active: true)
    redirect_to admin_events_path, notice: "#{ids.count} events activated"
  end

  batch_action :deactivate do |ids|
    Event.where(id: ids).update_all(active: false)
    redirect_to admin_events_path, notice: "#{ids.count} events deactivated"
  end

  batch_action :mark_as_featured do |ids|
    Event.where(id: ids).update_all(featured: true)
    redirect_to admin_events_path, notice: "#{ids.count} events marked as featured"
  end

  batch_action :remove_featured do |ids|
    Event.where(id: ids).update_all(featured: false)
    redirect_to admin_events_path, notice: "#{ids.count} events removed from featured"
  end
end