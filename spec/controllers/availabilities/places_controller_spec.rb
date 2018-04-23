# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Availabilities::PlacesController, type: :controller do
  describe 'GET #index' do
    context 'unauthenticated' do
      it do
        expect do
          get :index
        end.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'normal user' do
      it do
        sign_in create(:user)
        expect do
          get :index
        end.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'admin' do
      it do
        user = create(:user)
        user.add_role(:admin)
        sign_in user
        get :index
        should respond_with :ok
      end
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
    it { should respond_with :ok }
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
