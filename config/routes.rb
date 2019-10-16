Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  resources :users, path: 'welcome', path_names: { new: '' },
    only: [:new, :create]

  root to: "users#new"

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
