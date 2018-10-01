# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET static_pages#guide' do
    before do
      sign_in create(:user)
      get :guide
    end

    it { should respond_with :ok }
  end
end
