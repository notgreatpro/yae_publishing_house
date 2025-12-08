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
  end

  resources :wishlists, only: [:index, :create, :destroy]
  delete 'wishlists/product/:product_id', to: 'wishlists#destroy_by_product', as: 'remove_from_wishlist'
  
  
  resources :categories, only: [:index, :show]
  

  get 'cart', to: 'cart#show'
  post 'cart/add', to: 'cart#add'
  patch 'cart/update/:product_id', to: 'cart#update', as: 'cart_update'
  delete 'cart/remove/:product_id', to: 'cart#remove', as: 'cart_remove'
  delete 'cart/clear', to: 'cart#clear', as: 'cart_clear'
  
  
  resource :checkout, only: [:show, :create], controller: 'checkout'
  

  resources :orders, only: [:index, :show] do
    member do
      get 'confirmation'
    end
  end

   resources :products do
    resources :ratings, only: [:create, :update, :destroy]
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
end