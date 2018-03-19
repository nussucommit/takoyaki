# frozen_string_literal: true

class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @time_ranges = TimeRange.order(:start_time)
    @availabilities = load_availabilities
    @start_time = start_time
    @end_time = end_time
  end

  def update_availabilities
    availability_ids = params[:availability_ids] || []
    Availability.where(user_id: current_user.id).each do |availability|
      availability.update(status:
        availability_ids.include?(availability.id.to_s))
    end
    redirect_to availabilities_path
  end

  private

  def load_availabilities
    Array.new(7) { |day| get_availabilities_day(day) }
  end

  def get_availabilities_day(day)
    @time_ranges.each.map { |time_range| get_availability(day, time_range.id) }
  end

  def get_availability(day, time_range_id)
    Availability.find_or_create_by(user_id: current_user.id, day: day,
                                   time_range_id: time_range_id)
  end
  
  def start_time
    @time_ranges.first.start_time.beginning_of_hour
  end

  def end_time
    (@time_ranges.last.end_time - 1).beginning_of_hour + 1.hour
  end
end
