# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'duties#index'

  resources :availabilities, only: [:index] do
    collection do
      post '/', to: 'availabilities#update_availabilities'
      get '/show_everyone', to: 'availabilities#show_everyone'
    end
  end

  namespace :availabilities do
    resources :places, only: %i[index edit update]
  end

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users

  resources :duties do
    collection do
      post 'generate', to: 'duties#generate_duties'
    end
  end
  resources :announcements, only: %i[index create destroy update]

  get 'home', to: 'home#index'

  resources :problem_reports, only: %i[index create new update]
end
