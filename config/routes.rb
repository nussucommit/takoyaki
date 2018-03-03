# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, path_prefix: 'my', controllers: { registrations:
    'registrations' }

  resources :users

  # For details on the DSL available within this file, see http://
  # guides.rubyonrails.org/routing.html
  resources :announcements, only: %i[index create destroy update]
end
