# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DutiesController, type: :controller do
  describe 'GET #index' do
    before do
      sign_in create(:user)
      create_list(:time_range, 10)
      create(:timeslot)
      Duty.generate(Time.zone.today.beginning_of_week, Time.zone.today + 7)
      get :index
    end

    it { should respond_with :ok }
  end

  describe 'POST duties#generate_duties' do
    before do
      sign_in create(:user)
      create_list(:time_range, 10)
      create(:timeslot)
      post :generate_duties, params: { num_weeks: 1 }
    end

    it { should redirect_to duties_path }
  end

  describe 'POST duties#grab' do
    before do
      sign_in create(:user)
    end

    it 'grab a duty' do
      @duty = create(:duty)
      expect do
        patch :grab, params: { duty_id: [@duty.id] }
      end.to change { Duty.find(@duty.id).user }.to(subject.current_user)
      expect(Duty.find(@duty.id).free).to be(false)
      expect(Duty.find(@duty.id).request_user_id).to be(nil)
      should redirect_to duties_path
    end
  end

  describe 'POST duties#drop' do
    before do
      sign_in create(:user)
    end

    it 'drop a duty to all' do
      @duty = create(:duty)
      expect do
        patch :drop, params: { duty_id: [@duty.id], user_id: 0 }
      end.to change { Duty.find(@duty.id).free }.to(true)
      should redirect_to duties_path
    end

    it 'drop a duty to someone' do
      @duty = create(:duty)
      @user = create(:user)
      expect do
        patch :drop, params: { duty_id: [@duty.id], user_id: @user.id }
      end.to change { Duty.find(@duty.id).request_user_id }.to(@user.id)
      should redirect_to duties_path
    end
  end
end
