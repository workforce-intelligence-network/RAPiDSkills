Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root to: "vuejs#index"

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  # Helpers for vue routes
  get '/signup' => "vuejs#index", as: 'new_registration'
  get '/logins' => "vuejs#index", as: 'new_session'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :occupations, only: [:index, :show]
      resources :occupation_standards, except: [:new, :edit] do
        member do
          get "relationships/work_processes", to: "occupation_standards/relationships/work_processes#index"
          delete "relationships/work_processes", to: "occupation_standards/relationships/work_processes#destroy"
          get "relationships/skills", to: "occupation_standards/relationships/skills#index"
          delete "relationships/skills", to: "occupation_standards/relationships/skills#destroy"
          get "relationships/creator", to: "occupation_standards/relationships#creator"
          get "relationships/industry", to: "occupation_standards/relationships#industry"
          get "relationships/occupation", to: "occupation_standards/relationships#occupation"
          get "relationships/organization", to: "occupation_standards/relationships#organization"
          get "relationships/registration_state", to: "occupation_standards/relationships#registration_state"
          get "relationships/parent_occupation_standard", to: "occupation_standards/relationships#parent_occupation_standard"
        end
        resources :occupation_standard_work_processes, path: "work_processes", only: [:index]
        resources :occupation_standard_skills, path: "skills", only: [:index], to: "occupation_standards/occupation_standard_skills#index"
      end

      resources :occupation_standard_work_processes, path: "work_processes", only: [:show, :create, :update] do
        member do
          get "relationships/skills", to: "occupation_standard_work_processes/relationships/skills#index"
          delete "relationships/skills", to: "occupation_standard_work_processes/relationships/skills#destroy"
          get "relationships/categories", to: "occupation_standard_work_processes/relationships/categories#index"
          delete "relationships/categories", to: "occupation_standard_work_processes/relationships/categories#destroy"
        end
        resources :occupation_standard_skills, path: "skills", only: [:index], controller: "occupation_standard_work_processes/occupation_standard_skills"
        resources :categories, only: [:index], controller: "occupation_standard_work_processes/categories"
      end

      resources :occupation_standard_skills, path: "skills", only: [:create, :show, :update, :index]
      resources :categories, only: [:create, :show, :update] do
        member do
          get "relationships/skills", to: "categories/relationships/skills#index"
          delete "relationships/skills", to: "categories/relationships/skills#destroy"
        end
        resources :occupation_standard_skills, path: "skills", only: [:index], controller: "categories/occupation_standard_skills"
      end
      resources :industry, only: [:show]
      resources :organizations, only: [:show]
      resources :states, only: [:show]
      resources :leads, only: [:create]
      resources :users, only: [:create, :show, :update] do
        member do
          get "relationships/favorites", to: "users/relationships/favorites#index"
          post "relationships/favorites", to: "users/relationships/favorites#create"
          delete "relationships/favorites", to: "users/relationships/favorites#destroy"

          get "relationships/occupation_standards", to: "users/relationships/occupation_standards#index"
        end
        resources :favorites, only: [:index], controller: "users/favorites"
        resources :occupation_standards, only: [:index], controller: "users/occupation_standards"
      end

      resources :passwords, only: [:create, :update], controller: "passwords"

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
