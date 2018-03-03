# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    Bullet.enable = false
    time_range = TimeRange.order(:start_time)
    first = time_range.first.start_time
    @header_iter = first.to_i.step(time_range.last.start_time.to_i, 1.hour)
    @start_date = Time.zone.today.beginning_of_week
    @end_date = @start_date + 6.days
    @places = Place.all
  end

  def generate_duties
    start_date = Date.today.beginning_of_week
    end_date = start_date + (params[:num_weeks].to_i * 7 - 1).days
    Duty.generate(start_date, end_date)
    redirect_to duties_path
  end
end
  
