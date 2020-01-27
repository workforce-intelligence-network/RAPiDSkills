Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root to: "vuejs#index"

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :occupations, only: [:index, :show]
      resources :occupation_standards, only: [:index, :show, :create, :destroy] do
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
      resources :leads, only: [:create]
      resources :users, only: [:create] do
        member do
          get "relationships/favorites", to: "users/relationships/favorites#index"
          post "relationships/favorites", to: "users/relationships/favorites#create"
          delete "relationships/favorites", to: "users/relationships/favorites#destroy"

          get "relationships/occupation_standards", to: "users/relationships/occupation_standards#index"
        end
        resources :favorites, only: [:index], controller: "users/favorites"
        resources :occupation_standards, only: [:index], controller: "users/occupation_standards"
      end

      resources :client_sessions, path: "sessions", only: [:create, :destroy, :show], controller: "sessions" do
        member do
          get "relationships/user", to: "sessions/relationships#user"
        end
        resource :user, only: [:show], controller: "sessions/user"
      end

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
