# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AvailabilitiesController, type: :controller do
  describe 'GET availabilities#index' do
    before do
      create_list(:time_range, 10)
      sign_in create(:user), scope: :user
      get :index
    end
    it { should respond_with :ok }
  end

  describe 'POST availabilities#update_availabilities' do
    before do
      sign_in create(:user), scope: :user
      create_list(:time_range, 10)
      post :update_availabilities, params: { availability_ids: {} }
    end

    it { should redirect_to availabilities_path }
  end
end
