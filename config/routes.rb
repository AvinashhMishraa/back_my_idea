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

  post "checkouts/show", to: "checkouts#show"

  resource :subscription

  root to: 'projects#index'
end