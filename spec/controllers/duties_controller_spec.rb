# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DutiesController, type: :controller do
  describe 'GET #index' do
    before do
      create_list(:time_range, 10)
      create(:timeslot)
      Duty.generate(Time.zone.today.beginning_of_week, Time.zone.today + 7)
      get :index
    end
    it { should respond_with :ok }
  end
  describe 'POST duties#generate_duties' do
    before do
      create_list(:time_range, 10)
      create(:timeslot)
      post generate_duties_path, params: { num_weeks: 1 }
    end
    it { should redirect_to duties_path }
  end
end
