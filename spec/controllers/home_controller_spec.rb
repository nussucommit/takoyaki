# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    it 'unauthenticated' do
      get :index
      should redirect_to(new_user_session_path)
    end
    it 'authenticated' do
      sign_in create(:user)
      get :index
      should respond_with :ok
    end
  end
end
