# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'duties#index'

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
