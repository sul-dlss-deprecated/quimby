Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root to: 'repositories#index'
  get 'repositories/index'
end
