# frozen_string_literal: true

class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @time_ranges = TimeRange.order(:start_time)
    @availabilities = load_availabilities
    create_missing_availabilities
    @start_time = start_time
    @end_time = end_time
  end

  def update_availabilities
    availability_ids = params[:availability_ids] || []
    Availability.where(user_id: current_user.id).each do |availability|
      available = availability_ids.include?(availability.id.to_s)
      availability.update(status: available) if availability.status != available
    end
    redirect_to availabilities_path
  end

  private

  def load_availabilities
    Hash[Availability.where(user: current_user).joins(:time_range)
                     .order('day', 'time_ranges.start_time')
                     .to_a.map do |availability|
           [[availability.day, availability.time_range_id], availability]
         end
    ]
  end

  def create_missing_availabilities
    Availability.days.each do |day, _index|
      @time_ranges.each do |time_range|
        next if @availabilities.key?([day, time_range.id])
        @availabilities[[day, time_range.id]] = Availability.create(
          user_id: current_user.id, day: day,
          time_range_id: time_range.id, status: false
        )
      end
    end
  end

  def start_time
    @time_ranges.first.start_time.beginning_of_hour
  end

  def end_time
    (@time_ranges.last.end_time - 1).beginning_of_hour + 1.hour
  end
end
