# frozen_string_literal: true

class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!
  def index
    @time_ranges = TimeRange.all.to_a.sort_by! { |x| x.start_time }
    @availabilities = load_availabilities
    @start_time = get_start_time
    @end_time = get_end_time
  end

  def create
    availability_ids = unless params.key?(:availability_ids) 
      then [] else params[:availability_ids] end
    Availability.where(user_id: current_user.id).each do |availability|
      set(availability,
        availability_ids.include?(availability.id.to_s))
    end
  end

  def set(availability, status)
    availability.status = status ? 1 : 0
    availability.save
  end

  def load_availabilities
    availabilities = []
    7.times { |day| availabilities.push(get_availabilities_day(day)) }
    availabilities
  end

  def get_availabilities_day(day)
    availabilities = []

    @time_ranges.each do |time_range|
      availabilities.push(get_availability(day, time_range.id))
    end
    availabilities
  end

  def get_availability(day, time_range_id)
    Availability.where(user_id: current_user.id, day: day,
                       time_range_id: time_range_id)[0] ||
      create_new_availability(day, time_range_id)
  end

  def create_new_availability(day, time_range_id)
    Availability.create(user_id: current_user.id, day: day,
                        time_range_id: time_range_id)
  end
  
  def get_start_time
    @time_ranges[0].start_time.beginning_of_hour
  end

  def get_end_time
    (@time_ranges[-1].end_time-1).beginning_of_hour + 3600
  end
  
end
