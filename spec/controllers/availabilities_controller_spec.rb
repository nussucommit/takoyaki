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

    it do
      should respond_with :ok
      assert_template :index
    end

    it 'creates availability' do
      TimeRange.all.all? do |time_range|
        Availability.exists?(user: @user, time_range: time_range)
      end
      assert_template :index
    end

    context 'with availabilities' do
      before do
        create(:availability)
        get :index
      end

      it do
        should respond_with :ok
        assert_template :index
      end
    end
  end

  describe 'POST availabilities#update_availabilities' do
    before do
      @user = create(:user)
      sign_in @user, scope: :user
      create_list(:time_range, 10)
      get :index
    end

    it 'redirects to availabilities_path' do
      post :update_availabilities, params: { availability_ids: [] }
      should redirect_to availabilities_path
    end

    it 'should not create new availability' do
      expect do
        post :update_availabilities, params: { availability_ids: [] }
      end.to change(Availability, :count).by(0)
    end

    it 'updates availability status to true' do
      @availability = Availability.take
      @availability.update(status: false)
      expect do
        post :update_availabilities, params: {
          availability_ids: [@availability.id]
        }
      end.to change {
        Availability.find(@availability.id).status
      }.from(false).to(true)
    end

    it 'updates availability status to false' do
      @availability = Availability.take
      @availability.update(status: true)
      expect do
        post :update_availabilities, params: { availability_ids: [] }
      end.to change {
        Availability.find(@availability.id).status
      }.from(true).to(false)
    end
  end

  describe 'GET availabilities#show_everyone' do
    before do
      create_list(:time_range, 10)
      user = create(:user)
      user.add_role(:admin)
      sign_in user, scope: :user
    end
    context 'without availabilities' do
      before { get :show_everyone }
      it do
        should respond_with :ok
        assert_template :show_everyone
      end
    end
    context 'with availabilities' do
      before do
        create(:availability)
        get :show_everyone
      end
      it do
        should respond_with :ok
        assert_template :show_everyone
      end
    end
  end
end
