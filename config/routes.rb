Rails.application.routes.draw do
  # Customer-facing routes (public store)
  root 'products#index'  # This is your front page for customers! ⭐
  
  resources :products, only: [:index, :show] do
    collection do
      get 'search'  # For future feature 2.6 (search)
    end
  end
  
  # You can add category browsing later for feature 2.2
  resources :categories, only: [:show]
  
  # Admin namespace
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    root 'dashboard#index'  # Admin dashboard home
    
    # Product CRUD routes (admin only)
    resources :products
    resources :categories
    resources :authors
    
    # For future: Edit About & Contact pages (Feature 1.4)
    resource :site_content, only: [:edit, :update]
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end