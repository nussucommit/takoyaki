# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Duties::PlacesController, type: :controller do
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
      timeslot = create(:timeslot, time_range: @time_range, place: @place)
      @duty = create(:duty, timeslot: timeslot, user: user, free: false,
                            request_user: create(:user),
                            date: Time.zone.today + 2.weeks)
      @start_date = @duty.date.beginning_of_week
    end

    it do
      @duty.update(free: true)
      user = create(:user)
      old_user_id = @duty.user_id

      expect do
        put :update, params: { id: @place.id,
                               duty: { @duty.id.to_s => user.id.to_s } }
        @duty.reload
      end.to change {
        @duty.user_id
      }.from(old_user_id).to(user.id)
      should redirect_to(edit_duties_place_path(id: @place.id,
                                                start_date: @start_date))
    end

    it 'preserves dropped status' do
      @duty.update(free: false)
      user = create(:user)

      expect do
        put :update, params: { id: @place.id,
                               duty: { @duty.id.to_s => user.id.to_s } }
        @duty.reload
      end.not_to change {
        @duty.free
      }.from(false)
    end

    it 'clears request_user' do
      @duty.update(free: true)
      user = create(:user)
      request_user_id = @duty.request_user_id
      expect do
        put :update, params: { id: @place.id,
                               duty: { @duty.id.to_s => user.id.to_s } }
        @duty.reload
      end.to change {
        @duty.request_user_id
      }.from(request_user_id).to(nil)
    end
  end
end
