# frozen_string_literal: true

class ProblemReportsController < ApplicationController
  def index 
    @problem_reports = ProblemReport.all
  end

  def new
    # @test = "bum"
  end
  
  def create
    @problem_report = ProblemReport.new
    @problem_report.reporter_user_id = current_user.id
    @problem_report.reporter_user = current_user
    @problem_report.last_update_user_id = current_user.id
    @problem_report.last_update_user = current_user
    @problem_report.computer_number = params[:computer_number]
    @problem_report.description = params[:description]
    @problem_report.is_critical = params[:is_critical]
    @problem_report.is_fixed = false
    @problem_report.is_fixable = true
    @problem_report.is_blocked = false
    @problem_report.place_id = Place.find_by_name(params[:venue_AS8] ? 'AS8' : 'YIH').id
    @problem_report.place = Place.find_by_name(params[:venue_AS8] ? 'AS8' : 'YIH')
    if @problem_report.save!
      redirect_to problem_reports_path
    else 
      redirect_to new_problem_report_path
    end
  end
  
  def update; end

  def delete; end
end
