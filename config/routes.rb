Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  resources :users, path: 'welcome', path_names: { new: '' },
    only: [:new, :create]

  root to: "vuejs#index"

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :occupations, only: [:index]
      resources :occupation_standards, only: [:index]

      resources :users, only: [:create]

      resources :sessions, only: [:create]
      delete "sessions", to: "sessions#destroy"

      authenticate :user, lambda { |u| u.admin? } do
        mount Docs::API, at: '/docs'
      end
    end
  end

  mount Vuejs::Run, at: '/dist'
  get '*path', controller: 'vuejs', action: 'index', as: :vuejs
end
