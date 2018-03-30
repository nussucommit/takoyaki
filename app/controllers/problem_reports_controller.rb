# frozen_string_literal: true

class ProblemReportsController < ApplicationController
  def index 
    @problem_reports = ProblemReport.all
  end

  def create; end

  def update; end

  def delete; end
end
