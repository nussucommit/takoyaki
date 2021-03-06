# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Availabilities::PlacesController, type: :controller do
  describe 'GET #index' do
    it 'denies access when unauthenticated' do
      get :index
      should redirect_to(new_user_session_path)
    end
    it 'denies access to normal user' do
      sign_in create(:user)
      get :index
      should redirect_to(root_path)
    end
    it 'renders for admin' do
      user = create(:user)
      user.add_role(:admin)
      sign_in user
      get :index
      should respond_with :ok
      assert_template :index
    end
  end
  describe 'GET #edit' do
    before do
      create(:availability)
      @place = create(:place)
      create(:timeslot, place: @place)
      user = create(:user)
      user.add_role(:admin)
      sign_in user
      get :edit, params: { id: @place }
    end
    it do
      should respond_with :ok
      assert_template :edit
    end
  end
  describe 'PUT #update' do
    before do
      user = create(:user)
      user.add_role(:admin)
      sign_in user
      @place = create(:place)
      @time_range = create(:time_range)
      @timeslot = create(:timeslot, time_range: @time_range, place: @place)
    end
    it do
      user = create(:user)
      old_user_id = @timeslot.default_user_id
      expect do
        put :update, params: { id: @place.id,
                               "#{Availability.days[@timeslot.day]}" \
                               "#{@time_range.id}" => user.id }
      end.to change {
        Timeslot.find(@timeslot.id).default_user_id
      }.from(old_user_id).to(user.id)
      should redirect_to(edit_availabilities_place_path(id: @place.id))
    end
  end
end
