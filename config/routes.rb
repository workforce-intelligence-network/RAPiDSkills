Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: "admin/dashboard#index"
  ActiveAdmin.routes(self)

  resources :users, path: 'welcome', path_names: { new: '' },
    only: [:new, :create]
end
