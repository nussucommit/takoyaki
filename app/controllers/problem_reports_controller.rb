# frozen_string_literal: true

class ProblemReportsController < ApplicationController
  def index
    @problem_reports = ProblemReport.order(id: :desc)
    filter_encode

    if params[:filter] == 'Unfixed and Critical'
      @problem_reports.where!(is_critical: true, is_fixed: false)
    elsif params[:filter] == 'Unfixed and Fixable'
      @problem_reports.where!(is_fixable: true, is_fixed: false)
    end
  end

  def new; end

  def create
    create_new_report
    if @report.save
      flash[:notice] = 'Success'
      redirect_to problem_reports_path
    else
      flash[:notice] = 'Fail'
      redirect_to new_problem_report_path
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

  def filter_encode
    params[:filter] = if !params[:filter]
                        'Unfixed and Fixable'
                      else
                        params[:filter][5..-10]
                      end
  end

  def create_new_report
    @report = ProblemReport.new
    @report.reporter_user_id = current_user.id
    @report.last_update_user_id = current_user.id
    @report.is_fixed = false
    @report.is_fixable = true
    @report.is_blocked = false
    @report.place_id = Place.find_by(name: params[:venue]).id
    assign_from_params
  end

  def assign_from_params
    @report.computer_number = params[:computer_number]
    @report.description = params[:description]
    @report.is_critical = params[:is_critical]
  end
end
