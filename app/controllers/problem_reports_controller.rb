# frozen_string_literal: true

class ProblemReportsController < ApplicationController
  def index
    @problem_reports = ProblemReport.order(id: :desc)
    @filter = filter_message
    
    if params[:all_problems]
      @filter = "All"
    elsif params[:critical_problems]
      @filter = "Unfixed and Critical"
      @problem_reports = @problem_reports.where(is_critical: true,
        is_fixed: false)
    else
      @filter = "Unfixed and Fixable"
      @problem_reports = @problem_reports.where(is_fixable: true,
        is_fixed: false)
    end
      
  end

  def new; end

  def create
    if new_report.save
      redirect_to problem_reports_path,
                  notice: 'New Problem Report Created'
    else
      redirect_to new_problem_report_path,
                  alert: 'Fail To Make New Problem Report!'
    end
  end

  def update
    @report = ProblemReport.find(params[:id])
    update_remarks if params[:remarks]
    update_bool_attr
    redirect_to problem_reports_path
  end

  private

  def update_remarks
    @report.update(last_update_user_id: current_user.id,
                   remarks: params[:remarks])
  end

  def update_bool_attr
    %w[is_fixable is_fixed is_blocked is_critical].each do |a|
      @report.update(a => !@report[a]) if params[a]
    end
  end

end
