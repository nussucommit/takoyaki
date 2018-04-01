# frozen_string_literal: true

class ProblemReportsController < ApplicationController
  def index
    @problem_reports = ProblemReport.order(id: :desc)
    @filter = filter_message
    if @filter == 'Unfixed and Critical'
      @problem_reports = @problem_reports.where(is_critical: true,
                                                is_fixed: false)
    elsif @filter == 'Unfixed and Fixable'
      @problem_reports = @problem_reports.where(is_fixable: true,
                                                is_fixed: false)
    end
  end

  def new; end

  def create
    if create_new_report.save
      redirect_to problem_reports_path, notice: 'Success'
    else
      redirect_to new_problem_report_path, notice: 'Fail'
    end
  end

  def update
    update_remarks
    %w[is_fixable is_fixed is_blocked is_critical].each do |a|
      if params[a]
        val = !@report.public_send(a)
        @report.public_send("#{a}=", val)
      end
    end

    @report.save
    redirect_to problem_reports_path
  end

  def update_remarks
    @report = ProblemReport.find(params[:id])
    @report.last_update_user_id = current_user.id
    @report.remarks = params[:remarks] if params[:remarks]
  end

  private

  def filter_message
    if !params[:filter]
      'Unfixed and Fixable'
    else
      params[:filter][5..-10]
    end
  end

  def create_new_report
    ProblemReport.new(reporter_user_id: current_user.id,
                      last_update_user_id: current_user.id,
                      is_fixed: false,
                      is_fixable: true,
                      is_blocked: false,
                      place_id: Place.find_by(name: params[:venue]).id,
                      computer_number: params[:computer_number],
                      description: params[:description],
                      is_critical: params[:is_critical])
  end
end
