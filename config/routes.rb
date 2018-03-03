# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :duties do
    collection do
      post 'generate', to: 'duties#generate_duties'
    end
  end

  resources :announcements, only: %i[index create destroy update]
end
