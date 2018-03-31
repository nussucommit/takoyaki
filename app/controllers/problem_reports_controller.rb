# frozen_string_literal: true

class ProblemReportsController < ApplicationController
  def index 
    @problem_reports = ProblemReport.order(id: :desc)
    if !params[:filter]; params[:filter] = "Unfixed and Fixable"
    else params[:filter] = params[:filter][5..-10] end
    
    if params[:filter] == "Unfixed and Critical"
      @problem_reports.where!(is_critical: true, is_fixed: false)
    elsif params[:filter] == "Unfixed and Fixable"
      @problem_reports.where!(is_fixable: true, is_fixed: false)
    end
  end

  def new
  end
  
  def create
    report = ProblemReport.new
    report.reporter_user_id = current_user.id
    report.reporter_user = current_user
    report.last_update_user_id = current_user.id
    report.last_update_user = current_user
    report.computer_number = params[:computer_number]
    report.description = params[:description]
    report.is_critical = params[:is_critical]
    report.is_fixed = false
    report.is_fixable = true
    report.is_blocked = false
    report.place = Place.find_by_name(params[:venue])
    report.place_id = report.place.id
    
    if report.save
      flash[:notice] = "Success"
      redirect_to problem_reports_path
    else 
      flash[:notice] = "Fail"
      redirect_to new_problem_report_path
    end
  end
  
  def update
    report = ProblemReport.find(params[:id])
    report.last_update_user_id = current_user.id
    if params[:remarks]
      report.remarks = params[:remarks]
    end
    
    ['is_fixable', 'is_fixed', 'is_blocked', 'is_critical'].each do |a|
      if params[a]
        val = !report.send(a)
        report.send("#{a}=",val)
      end
    end
    
    report.save
    redirect_to problem_reports_path
  end
end
