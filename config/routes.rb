Rails.application.routes.draw do
  root "products#index"
  resources :products, only: [:index, :show]

  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

  resources :orders, only: [:new, :create, :show]
  
  namespace :admin do
    resources :products
    resources :orders, only: [:index, :show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
