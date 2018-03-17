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
      set(availability,
          availability_ids.include?(availability.id.to_s))
    end
    redirect_to availabilities_path
  end

  private

  def set(availability, status)
    availability.update(status: status)
  end

  def load_availabilities
    Array.new(7) { |day| get_availabilities_day(day) }
  end

  def get_availabilities_day(day)
    @time_ranges.each.map { |time_range| get_availability(day, time_range.id) }
  end

  def get_availability(day, time_range_id)
    Availability.find_by(user_id: current_user.id, day: day,
                         time_range_id: time_range_id) ||
      create_new_availability(day, time_range_id)
  end

  def create_new_availability(day, time_range_id)
    Availability.create(user_id: current_user.id, day: day,
                        time_range_id: time_range_id)
  end

  def start_time
    @time_ranges[0].start_time.beginning_of_hour
  end

  def end_time
    (@time_ranges[-1].end_time - 1).beginning_of_hour + 1.hour
  end
end
