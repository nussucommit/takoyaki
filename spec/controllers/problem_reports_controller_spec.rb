# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProblemReportsController, type: :controller do
  describe "GET problem_reports#index" do
    before do
      sign_in create(:user)
      get :index
    end
    
    it { should respond_with :ok }
  end
  
  describe "POST problem_reports#create" do
    before do
      sign_in create(:user)
      @venue = create(:place).name
    end
    
    it "should redirect to problem_reports_path" do
      post :create, params: {venue: @venue, computer_number: "A10", description: "I'm too rich"} 
      should redirect_to problem_reports_path
    end
    
    it "should redirect to new_problem_report_path" do
      post :create, params: {venue: @venue, computer_number: "", description: "I'm too rich"} 
      should redirect_to new_problem_report_path
      
      post :create, params: {venue: @venue, computer_number: "", description: ""} 
      should redirect_to new_problem_report_path
      
      post :create, params: {venue: @venue, computer_number: "A10", description: ""} 
      should redirect_to new_problem_report_path
    end
  end
  
  describe "GET problem_reports#new" do
    before do
      sign_in create(:user)
      get :new
    end
    
    it { should respond_with :ok }
  end
  
  describe "PATCH problem_reports#update" do
    before do
      sign_in create(:user)
      @report = create(:problem_report)
    end
    
    it "should redirect to problem_reports_path" do
      patch :update, params: {id: @report.id, remarks: "I'm super Rich"}
      should redirect_to problem_reports_path
      
      patch :update, params: {id: @report.id, is_fixable: "change"}
      should redirect_to problem_reports_path
      
      patch :update, params: {id: @report.id, is_fixed: "change"}
      should redirect_to problem_reports_path
      
      patch :update, params: {id: @report.id, is_blocked: "change"}
      should redirect_to problem_reports_path
      
      patch :update, params: {id: @report.id, is_critical: "change"}
      should redirect_to problem_reports_path
    end
    
    it "should change the remarks" do
      expect{
        patch :update, params: {id: @report.id, remarks: "I'm super duper Rich"}
      }.to change{ ProblemReport.find(@report.id).remarks }.to("I'm super duper Rich")
    end
    
    it "should change the is_fixable" do
      expect{
        patch :update, params: {id: @report.id, is_fixable: "change"}
      }.to change{ ProblemReport.find(@report.id).is_fixable }.to(true)
      
      expect{
        patch :update, params: {id: @report.id, is_fixable: "change"}
      }.to change{ ProblemReport.find(@report.id).is_fixable }.to(false)
    end
    
    it "should change the is_fixed" do
      expect{
        patch :update, params: {id: @report.id, is_fixed: "change"}
      }.to change{ ProblemReport.find(@report.id).is_fixed }.to(true)
      
      expect{
        patch :update, params: {id: @report.id, is_fixed: "change"}
      }.to change{ ProblemReport.find(@report.id).is_fixed }.to(false)
    end
    
    it "should change the is_blocked" do
      expect{
        patch :update, params: {id: @report.id, is_blocked: "change"}
      }.to change{ ProblemReport.find(@report.id).is_blocked }.to(true)
      
      expect{
        patch :update, params: {id: @report.id, is_blocked: "change"}
      }.to change{ ProblemReport.find(@report.id).is_blocked }.to(false)
    end
    
    it "should change the is_critical" do
      expect{
        patch :update, params: {id: @report.id, is_critical: "change"}
      }.to change{ ProblemReport.find(@report.id).is_critical }.to(true)
      
      expect{
        patch :update, params: {id: @report.id, is_critical: "change"}
      }.to change{ ProblemReport.find(@report.id).is_critical }.to(false)
    end
  end
end
