# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'duties#index'

  resources :availabilities, only: [:index] do
    collection do
      post '/', to: 'availabilities#update_availabilities'
      get '/default', to: 'availabilities#default'
      post '/set_default', to: 'availabilities#set_default'
      get '/all', to: 'availabilities#all'
    end
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
end
