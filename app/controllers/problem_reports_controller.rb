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

  def new
    @report = ProblemReport.new
  end

  def create
    report = ProblemReport.new report_params
    report.reporter_user = current_user
    report.last_update_user = current_user
    if report.save
      send_email(report)
      redirect_to problem_reports_path,
                  notice: 'Created new problem report'
    else
      @report = report
      flash.now[:alert] = "Failed to create problem report:
                          #{report.errors.full_messages.join(', ')}"
      render new_problem_report_path
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

  def report_params
    params.require(:problem_report).permit(:computer_number, :description,
                                           :is_critical, :place_id)
  end
end
