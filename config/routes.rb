Rails.application.routes.draw do
  # ActiveAdmin & Devise for Admin Users (ONLY ONE TIME!)
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Devise for Customers (Feature 3.1.4)
  devise_for :customers
  
  # Customer-facing routes (public store)
  root 'products#index'  
  
  # Products (Features 2.1, 2.3, 2.6)
  resources :products, only: [:index, :show] do
    collection do
      get 'search'  
      get 'on_sale'  
      get 'new_arrivals'  
      get 'recently_updated' 
    end
    
    resources :ratings, only: [:create, :update, :destroy]
  end

  resources :wishlists, only: [:index, :create, :destroy]
  delete 'wishlists/product/:product_id', to: 'wishlists#destroy_by_product', as: 'remove_from_wishlist'
  
  resources :categories, only: [:index, :show]
  
    # Cart routes
  get 'cart', to: 'cart#show', as: 'cart'
  post 'cart/add', to: 'cart#add', as: 'cart_add'
  post 'cart/apply_coupon', to: 'cart#apply_coupon', as: 'cart_apply_coupon'
  delete 'cart/remove_coupon', to: 'cart#remove_coupon', as: 'cart_remove_coupon'
  patch 'cart/update/:product_id', to: 'cart#update', as: 'cart_update'
  delete 'cart/remove/:product_id', to: 'cart#remove', as: 'cart_remove'
  delete 'cart/clear', to: 'cart#clear', as: 'cart_clear'
  
  # Checkout
  resource :checkout, only: [:show, :create], controller: 'checkout'

  # Events routes
  resources :events, only: [:index, :show]
  
  # Orders
  resources :orders, only: [:index, :show] do
    member do
      get 'confirmation'
    end
  end
  
  # Public Content Pages (Feature 1.4)
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'privacy', to: 'pages#privacy'      
  get 'terms', to: 'pages#terms'          
  
  # Customer profile routes
  get 'profile', to: 'customers#show', as: 'customer_profile'
  get 'profile/edit', to: 'customers#edit', as: 'edit_customer_profile'
  patch 'profile', to: 'customers#update'
  delete 'profile/picture', to: 'customers#remove_profile_picture', as: 'remove_profile_picture'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Public careers pages (customer-facing)
  resources :careers, only: [:index, :show] do
    # Nested application route
    member do
      get 'apply', to: 'job_applications#new', as: 'apply'
    end
  end
  
  # Job applications submission
  resources :job_applications, only: [:create], path: 'careers/applications'
end