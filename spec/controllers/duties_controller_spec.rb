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
      duty = create(:duty, free: true)
      expect do
        patch :grab, params: { duty_id: { duty.id => duty.id } }
        duty.reload
      end.to change { duty.user }.to(subject.current_user)
      expect(duty.free).to be(false)
      expect(duty.request_user_id).to be(nil)
      should redirect_to duties_path
      expect(flash[:notice]).to be('Duty successfully grabbed!')
    end

    it 'does nothing when no duties are grabbed' do
      patch :grab, params: { duty_id: {} }
      should redirect_to duties_path
      expect(flash[:alert]).to be('Error in grabbing duty! Please try again.')
    end

    it 'does nothing when nil duties are grabbed' do
      patch :grab, params: { duty_id: nil }
      should redirect_to duties_path
      expect(flash[:alert]).to be('Error in grabbing duty! Please try again.')
    end

    it 'does nothing when nonfree are grabbed' do
      duty = create(:duty, free: false)
      patch :grab, params: { duty_id: { duty.id => duty.id } }

      should redirect_to duties_path
      expect(flash[:alert]).to be('Error in grabbing duty! Please try again.')
    end
  end

  describe 'POST duties#drop' do
    before do
      @user = create(:user)
      sign_in @user
    end

    it 'drop a duty to all' do
      duty = create(:duty, user: @user)
      expect do
        patch :drop, params: { duty_id: { duty.id => duty.id }, user_id: 0 }
        duty.reload
      end.to change { duty.free }.to(true)
      should redirect_to duties_path
      expect(flash[:notice]).to be('Duty successfully dropped!')
    end

    it 'drop a duty to someone' do
      duty = create(:duty, user: @user)
      user = create(:user)
      expect do
        patch :drop, params: { duty_id: { duty.id => duty.id },
                               user_id: user.id }
        duty.reload
      end.to change { duty.request_user_id }.to(user.id)
      should redirect_to duties_path
    end

    it 'does nothing when no duties are dropped' do
      patch :drop, params: { duty_id: {} }
      should redirect_to duties_path
      expect(flash[:alert]).to be('Error in dropping duty! Please try again.')
    end

    it 'does nothing when nil duties are dropped' do
      patch :drop, params: { duty_id: nil }
      should redirect_to duties_path
      expect(flash[:alert]).to be('Error in dropping duty! Please try again.')
    end

    it 'does nothing when nil duty owners are dropped' do
      duty = create(:duty, user: nil)
      patch :drop, params: { duty_id: { duty.id => duty.id } }

      should redirect_to duties_path
      expect(flash[:alert]).to be('Error in dropping duty! Please try again.')
    end

    it 'does nothing when duty not owned by the user are dropped' do
      duty = create(:duty, user: create(:user))
      patch :drop, params: { duty_id: { duty.id => duty.id } }

      should redirect_to duties_path
      expect(flash[:alert]).to be('Error in dropping duty! Please try again.')
    end
  end
end
