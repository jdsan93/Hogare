Rails.application.routes.draw do
  get 'date_cleaner/edit'
  get 'cancel_service/cancel'
  patch 'orders/:id', to: 'orders#update', as: :update_order

  root 'home#index'

  devise_for :users 

  resources :the_users
  resources :date_cleaner, only: [:update, :edit]
  resources :clients,      only: [:edit, :update]
  resources :addresses
  resources :orders
  resources :services
  resources :cleaners,     only: [:edit, :update]
  resources :admins,       only: [:edit, :update]
  get '*path' => redirect('/')
end
