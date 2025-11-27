Rails.application.routes.draw do
  devise_for :customers
  # Customer-facing routes (public store)
  root 'products#index'  # This is your front page for customers! ⭐
  
  resources :products, only: [:index, :show] do
    collection do
      get 'search'  # Feature 2.6 - Search functionality ⭐
    end
  end
  
  # You can add category browsing later for feature 2.2
  resources :categories, only: [:show]
  resource :checkout, only: [:show, :create], controller: 'checkout'
  resources :orders, only: [:index, :show]

  # Shopping Cart routes (Features 3.1.1 & 3.1.2) - 8%
  get 'cart', to: 'cart#show'
  post 'cart/add', to: 'cart#add'
  patch 'cart/update/:product_id', to: 'cart#update', as: 'cart_update'
  delete 'cart/remove/:product_id', to: 'cart#remove', as: 'cart_remove'
  delete 'cart/clear', to: 'cart#clear', as: 'cart_clear'
  get 'orders/:id/confirmation', to: 'orders#confirmation', as: 'order_confirmation'
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