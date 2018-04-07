# frozen_string_literal: true

class ProblemReportsController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  def index
    @problem_reports = ProblemReport.order(id: :desc)
    if params[:all_problems]
      @filter = 'All'
    elsif params[:critical_problems]
      @filter = 'Unfixed and Critical'
      @problem_reports = @problem_reports.where(
        is_critical: true, is_fixed: false
      )
    else
      @filter = 'Unfixed and Fixable'
      @problem_reports = @problem_reports.where(
        is_fixable: true, is_fixed: false
      )
    end
  end
  # rubocop:enable Metrics/MethodLength

  def new; end

  def create
    report = new_report
    if report.save
      send_email(report)
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

  def send_email(report)
    GenericMailer.problem_report(report).deliver_later
  end

  def update_remarks
    @report.update(last_update_user_id: current_user.id,
                   remarks: params[:remarks])
  end

  def boolean_params
    params.permit(:is_fixable, :is_fixed, :is_blocked, :is_critical)
          .to_h
          .map { |k, v| [k, v.nil? ? @report[k] : !@report[k]] }
          .to_h
  end

  def update_bool_attr
    @report.update(boolean_params)
  end

  def new_report
    ProblemReport.new(reporter_user: current_user,
                      last_update_user: current_user,
                      place: Place.find_by(name: params[:venue]),
                      computer_number: params[:computer_number],
                      description: params[:description],
                      is_critical: params[:is_critical])
  end
end
