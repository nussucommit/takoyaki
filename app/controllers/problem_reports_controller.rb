# frozen_string_literal: true

class ProblemReportsController < ApplicationController
  def index 
    @problemReports = ProblemReport.all
  end

  def create; end

  def update; end

  def delete; end
end
