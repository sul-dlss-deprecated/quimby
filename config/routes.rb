Rails.application.routes.draw do
  root to: 'dashboard#index'
  resources :repositories, only: [:show, :index] do
    collection do
      get 'by_org'
      get 'by_top_5_lang'
      get 'by_lang_dlss'
      get 'by_lang_cidr'
    end
  end
  resources :servers, only: [:index]
  resources :dashboard, only: [:index]
end
