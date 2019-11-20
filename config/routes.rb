Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  root to: "vuejs#index"

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :occupations, only: [:index]
      resources :occupation_standards, only: [:index, :show] do
        member do
          get "relationships/work_processes", to: "occupation_standards/relationships#work_processes"
          get "relationships/skills", to: "occupation_standards/relationships#skills"
        end
        resources :work_processes, only: [:index]
        resources :skills, only: [:index]
      end

      resources :occupation_standard_work_processes, path: "work_processes", only: [:show] do
        member do
          get "relationships/skills", to: "occupation_standard_work_processes/relationships#skills"
        end
        resources :skills, only: [:index]
      end

      resources :skills, only: [:show]
      resources :users, only: [:create]

      resources :sessions, only: [:create]
      delete "sessions", to: "sessions#destroy"

      resources :downloads, only: [:create]

      authenticate :user, lambda { |u| u.admin? } do
        mount Docs::API, at: '/docs'
      end
    end
  end

  get '*path', controller: 'vuejs', action: 'index', as: :vuejs, constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
end
