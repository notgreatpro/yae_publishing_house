Rails.application.routes.draw do
  # Admin namespace
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    root 'dashboard#index'  # Admin dashboard home
    
    # Will add more admin routes here later (products, categories, etc.)
  end

  # Root path (customer-facing site - we'll build this later)
  root "products#index"
end