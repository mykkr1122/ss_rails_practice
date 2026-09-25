Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
     
      resources :orders, only: [:index, :create, :show] do
        resource :payment, only: [:show, :create], controller: "orders/payments"
      end

      resources :products, only: [:index, :show]
      resource :cart, only: [:show]
      resources :cart_items, only: [:create, :update, :destroy]
      
      resource :account, only: [:create, :update], controller: "registrations"

      namespace :admin do
        resources :orders, only: [:index, :show] do
          resource :completion, only: [:create], controller: "orders/completions"
        end
        resources :products
      end
    end
  end
  root "products#index"
  resources :products, only: [:index, :show]

  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

  resources :orders, only: [:index, :new, :create, :show] do
    resource :payment, only: [:show, :create], controller: 'orders/payments'
  end
  
  namespace :admin do
    resources :products
    resources :orders, only: [:index, :show] do
      resource :completion, only: [:create], controller: 'orders/completions'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
