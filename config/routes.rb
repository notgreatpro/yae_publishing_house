Rails.application.routes.draw do
  # ActiveAdmin & Devise for Admin Users (ONLY ONE TIME!)
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Devise for Customers (Feature 3.1.4)
  devise_for :customers
  
  # Customer-facing routes (public store)
  root 'products#index'  # Feature 2.1 - Front page ⭐
  
  # Products (Features 2.1, 2.3, 2.6)
  resources :products, only: [:index, :show] do
    collection do
      get 'search'  # Feature 2.6 - Search by keyword & category ⭐
      get 'on_sale'  # Feature 2.4 - Filter on sale
      get 'new_arrivals'  # Feature 2.4 - Filter new products
      get 'recently_updated'  # Feature 2.4 - Filter recently updated
    end
  end
  
  # Categories (Feature 2.2)
  resources :categories, only: [:index, :show]
  
  # Shopping Cart (Features 3.1.1 & 3.1.2) ⭐
  get 'cart', to: 'cart#show'
  post 'cart/add', to: 'cart#add'
  patch 'cart/update/:product_id', to: 'cart#update', as: 'cart_update'
  delete 'cart/remove/:product_id', to: 'cart#remove', as: 'cart_remove'
  delete 'cart/clear', to: 'cart#clear', as: 'cart_clear'
  
  # Checkout (Feature 3.1.3) ⭐
  resource :checkout, only: [:show, :create], controller: 'checkout'
  
  # Orders (Feature 3.2.1)
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
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end