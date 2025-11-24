Rails.application.routes.draw do
  # Admin namespace
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    root 'dashboard#index'  # Admin dashboard home
    
    # Product CRUD routes
    resources :products
  end

  # Temporary root - redirect to admin login for now
  root to: redirect('/admin/login')
  
  get "up" => "rails/health#show", as: :rails_health_check
end