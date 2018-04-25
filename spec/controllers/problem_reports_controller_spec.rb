# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProblemReportsController, type: :controller do
  describe 'GET problem_reports#index' do
    before do
      sign_in create(:user)
      get :index
    end

    it { should respond_with :ok }
  end

  describe 'POST problem_reports#create' do
    before do
      user = create(:user)
      user.add_role(:technical)
      sign_in user
      @venue = create(:place)
    end

    it 'should redirect to problem_reports_path and create new report' do
      post :create, params: { venue: @venue.name, computer_number: 'A10',
                              description: "I'm too rich" }
      should redirect_to problem_reports_path
      expect(ProblemReport.exists?(place_id: @venue.id, computer_number: 'A10',
                                   description: "I'm too rich")).to be true
    end

    it 'should redirect to new_problem_report_path and not create new report' do
      post :create, params: { venue: @venue.name, computer_number: '',
                              description: "I'm too rich" }
      should redirect_to new_problem_report_path

      post :create, params: { venue: @venue.name, computer_number: '',
                              description: '' }
      should redirect_to new_problem_report_path

      post :create, params: { venue: @venue.name, computer_number: 'A10',
                              description: '' }
      should redirect_to new_problem_report_path

      expect(ProblemReport.exists?(place_id: @venue.id)).to be false
    end
  end

  describe 'GET problem_reports#new' do
    before do
      sign_in create(:user)
      get :new
    end

    it { should respond_with :ok }
  end

  describe 'PATCH problem_reports#update' do
    before do
      sign_in create(:user)
    end

    it 'should change the remarks and redirect' do
      @report = create(:problem_report)
      expect do
        patch :update, params: { id: @report.id,
                                 remarks: "I'm super duper Rich" }
      end.to change { ProblemReport.find(@report.id).remarks }
        .to("I'm super duper Rich")
      should redirect_to problem_reports_path
    end

    it 'should change the is_fixable and redirect' do
      @report = create(:problem_report)
      expect do
        patch :update, params: { id: @report.id, is_fixable: 'change' }
      end.to change { ProblemReport.find(@report.id).is_fixable }.to(false)

      expect do
        patch :update, params: { id: @report.id, is_fixable: 'change' }
      end.to change { ProblemReport.find(@report.id).is_fixable }.to(true)
      should redirect_to problem_reports_path
    end

    it 'should change the is_fixed and redirect' do
      @report = create(:problem_report)
      expect do
        patch :update, params: { id: @report.id, is_fixed: 'change' }
      end.to change { ProblemReport.find(@report.id).is_fixed }.to(true)

      expect do
        patch :update, params: { id: @report.id, is_fixed: 'change' }
      end.to change { ProblemReport.find(@report.id).is_fixed }.to(false)
      should redirect_to problem_reports_path
    end

    it 'should change the is_blocked and redirect' do
      @report = create(:problem_report)
      expect do
        patch :update, params: { id: @report.id, is_blocked: 'change' }
      end.to change { ProblemReport.find(@report.id).is_blocked }.to(true)

      expect do
        patch :update, params: { id: @report.id, is_blocked: 'change' }
      end.to change { ProblemReport.find(@report.id).is_blocked }.to(false)
      should redirect_to problem_reports_path
    end

    it 'should change the is_critical and redirect' do
      @report = create(:problem_report)
      expect do
        patch :update, params: { id: @report.id, is_critical: 'change' }
      end.to change { ProblemReport.find(@report.id).is_critical }.to(true)

      expect do
        patch :update, params: { id: @report.id, is_critical: 'change' }
      end.to change { ProblemReport.find(@report.id).is_critical }.to(false)
      should redirect_to problem_reports_path
    end
  end
end
