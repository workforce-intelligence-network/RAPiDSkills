Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  resources :users, path: 'welcome', path_names: { new: '' },
    only: [:new, :create]

  root to: "users#new"

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  namespace :api, path: '', defaults: { format: :json } do
    namespace :v1 do
      resources :occupations, only: [:index]
      resources :occupation_standards, only: [:index]

      resources :users, only: [:create]

      authenticate :user, lambda { |u| u.admin? } do
        mount Docs::API, at: '/docs'
      end
    end
  end
end
