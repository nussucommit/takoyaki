# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'duties#index'

  resources :availabilities, only: [:index] do
    collection do
      post '/', to: 'availabilities#update_availabilities'
    end
  end

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users
  resources :duties do
    collection do
      post 'generate', to: 'duties#generate_duties'
      post 'open_drop_modal', to: 'duties#open_drop_modal', as: :open_drop_modal
      post 'open_grab_modal', to: 'duties#open_grab_modal', as: :open_grab_modal
      post 'grab', to: 'duties#grab'
      post 'drop', to: 'duties#drop'
    end
  end

  resources :announcements, only: %i[index create destroy update]

  get 'home', to: 'home#index'

  resources :problem_reports, only: %i[index create new update]
end
