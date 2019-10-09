Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  resources :users, path: 'welcome', path_names: { new: '' },
    only: [:new, :create]

  root to: "users#new"
end
