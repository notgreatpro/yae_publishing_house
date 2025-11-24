Rails.application.routes.draw do
  namespace :admin do
    root to: "dashboard#index"
    get "dashboard", to: "dashboard#index"
    # Add other admin routes here as you expand (e.g. resources :products)
  end

  # Temporary fallback for the root path to point to admin dashboard:
  root to: redirect('/admin')
end