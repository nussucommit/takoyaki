# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    Bullet.enable = false
    @start_date = Time.zone.today.beginning_of_week
    @end_date = @start_date + 6.days
    @places = Place.all
  end

  def generate_duties
    start_date = Time.zone.today.beginning_of_week
    end_date = start_date + (params[:num_weeks].to_i * 7 - 1).days
    Duty.generate(start_date, end_date)
    redirect_to duties_path
  end
end
