# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AvailabilitiesController, type: :controller do
  describe 'GET availabilities#index' do
    before do
      create_list(:time_range, 10)
      @user = create(:user)
      sign_in @user, scope: :user
      get :index
    end
    it { should respond_with :ok }
  end

end
