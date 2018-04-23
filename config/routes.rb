# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'duties#index'

  resources :availabilities, only: [:index] do
    collection do
      post '/', to: 'availabilities#update_availabilities'
    end
  end

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users do
    member do
      get 'allocate_role/', to: 'users#allocate_role', as: 'allocate_role'
      patch 'allocate_role/', to: 'users#update_role'
      put 'allocate_role/', to: 'users#update_role'
    end
  end

  resources :duties do
    collection do
      post 'generate', to: 'duties#generate_duties'
    end
  end
  resources :announcements, only: %i[index create destroy update]

  get 'home', to: 'home#index'

  resources :problem_reports, only: %i[index create new update]
end
