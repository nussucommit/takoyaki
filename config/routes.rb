# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users

  resources :availabilities, only: [:index] do
    collection do
      post '/', to: 'availabilities#update_availabilities'
    end
  end

  resources :duties do
    collection do
      post 'generate', to: 'duties#generate_duties'
    end
  end

  resources :announcements, only: %i[index create destroy update]
end
