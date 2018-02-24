# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :availabilities
  
  # post '/availabilities/indomie', to: 'availabilities#apalah'
  # get '/availabilities/indomie', to: 'availabilities#apalah2'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
