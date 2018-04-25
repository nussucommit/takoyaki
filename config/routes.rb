# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'duties#index'

  resources :availabilities, only: [:index] do
    collection do
      put '/', to: 'availabilities#update_availabilities'
      get '/show_everyone', to: 'availabilities#show_everyone'
    end
  end

  namespace :availabilities do
    resources :places, only: %i[index edit update]
  end

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users do
    member do
      get 'allocate_roles', to: 'users#allocate_roles', as: 'allocate_roles'
      patch 'allocate_roles', to: 'users#update_roles'
      put 'allocate_roles', to: 'users#update_roles'
    end
  end

  resources :duties do
    collection do
      post 'generate', to: 'duties#generate_duties'
      post 'open_drop_modal', to: 'duties#open_drop_modal'
      post 'open_grab_modal', to: 'duties#open_grab_modal'
      post 'grab', to: 'duties#grab'
      post 'drop', to: 'duties#drop'
    end
  end

  resources :announcements, only: %i[index create destroy update]

  get 'home', to: 'home#index'

  resources :problem_reports, only: %i[index create new update]
end
