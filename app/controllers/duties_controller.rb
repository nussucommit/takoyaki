# frozen_string_literal: true

class DutiesController < ApplicationController
  def index 

  def generate_duties
    start_date = Time.zone.today.beginning_of_week
    end_date = start_date + (7 * params[:num_weeks].to_i).day
    Duty.generate(start_date, end_date)
  end
end
