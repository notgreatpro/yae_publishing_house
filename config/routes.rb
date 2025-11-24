Rails.application.routes.draw do
  # Admin namespace
  namespace :admin do
    get "products/index"
    get "products/new"
    get "products/create"
    get "products/edit"
    get "products/update"
    get "products/destroy"
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    root 'dashboard#index'  # Admin dashboard home
  end

  # Temporary root - redirect to admin login for now
  root to: redirect('/admin/login')
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end