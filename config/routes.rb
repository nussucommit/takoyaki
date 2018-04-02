# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'duties#index'

  resources :availabilities, only: [:index] do
    collection do
      post '/', to: 'availabilities#update_availabilities'
      get '/default', to: 'availabilities#default_index'
      get '/default/places/:id', to: 'availabilities#default_edit'
      post '/default/places/:id', to: 'availabilities#default_update'
      get '/show_everyone', to: 'availabilities#show_everyone'
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
