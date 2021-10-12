require 'sidekiq/web'

Rails.application.routes.draw do
  # get 'checkout', to: "billing#show"

  get 'checkout', to: "checkouts#show"
  get 'billing', to: "billing#show"


  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :projects do
    resources :comments, module: :projects
  end

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  post "checkouts/show", to: "checkouts#show", as: "checkouts_show"
  get "success", to: "checkouts#success"
  get "cancel", to: "checkouts#cancel"

  resources :webhooks, only: [:create]

  # post "projects/add_to_cart/:id", to: "projects#add_to_cart", as: "add_to_cart"
  # delete "projects/remove_from_cart/:id", to: "projects#remove_from_cart", as: "remove_from_cart"

  post "projects/add_to_cart/:id", to: "shoppingcart#add_to_cart", as: "add_to_cart"
  delete "projects/remove_from_cart/:id", to: "shoppingcart#remove_from_cart", as: "remove_from_cart"
  get "checkout/cart", to: "shoppingcart#show", as: "shoppingcart"

  get "search", to: "projects#search"

  resource :subscription

  root to: 'projects#index'
end