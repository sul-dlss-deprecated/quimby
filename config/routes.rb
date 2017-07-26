Rails.application.routes.draw do
  root to: 'repositories#index'
  resources :repositories, only: [:show, :index]
  resources :servers, only: [:index]
end
