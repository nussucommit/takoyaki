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
      @duty=create(:duty)
      expect do
        patch :update, params: { duty_id: @duty.id }
      end.to change { Duty.find(@duty.id).user }.to(current_user)

      should redirect_to duties_path 
    end
  end

  describe 'POST duties#drop' do
    before do
      sign_in create(:user)
      
    end

    it 'drop a duty' do
      @duty=create(:duty)
      @duty.update(free: false)
      expect do
        patch :update, params: { duty_id: @duty.id, user_id: 0}
      end.to change { Duty.find(@duty.id).free }.to(true)
      should redirect_to duties_path
    end
  end
end
