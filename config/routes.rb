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
      resources :occupations, only: [:index, :show]
      resources :occupation_standards, only: [:index, :show, :create] do
        member do
          get "relationships/work_processes", to: "occupation_standards/relationships#work_processes"
          get "relationships/skills", to: "occupation_standards/relationships#skills"
          get "relationships/occupation", to: "occupation_standards/relationships#occupation"
          get "relationships/organization", to: "occupation_standards/relationships#organization"
        end
        resources :occupation_standard_work_processes, path: "work_processes", only: [:index]
        resources :occupation_standard_skills, path: "skills", only: [:index]
      end

      resources :occupation_standard_work_processes, path: "work_processes", only: [:show] do
        member do
          get "relationships/skills", to: "occupation_standard_work_processes/relationships#skills"
        end
        resources :occupation_standard_skills, path: "skills", only: [:index], controller: "occupation_standard_work_processes/occupation_standard_skills"
      end

      resources :occupation_standard_skills, path: "skills", only: [:show, :update]
      resources :organizations, only: [:show]
      resources :users, only: [:create] do
        member do
          post "relationships/favorites", to: "favorites#create"
          delete "relationships/favorites", to: "favorites#destroy"
        end
      end

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
