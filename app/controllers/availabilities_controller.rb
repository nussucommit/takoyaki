class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!
  def index
    @availabilities = load_availabilities()
  end

  def create
    Availability.where(user_id: current_user.id).each do |availability|
      set(availability, params[:availability_ids].include?(availability.id.to_s))
    end
  end

private

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
    TimeRange.all.each do |time_range|
      availabilities.push(get_availability(day, time_range.id))
    end
    availabilities
  end

  def get_availability(day, time_range_id)
    availability = Availability.where(user_id: current_user.id, day: day,
        time_range_id: time_range_id)[0]
    if availability.nil?
      availability = create_new_availability(day, time_range_id)
    availability
  end

  def create_new_availability(day, time_range_id)
    Availability.create(user_id: current_user.id, day: day,
        time_range_id: time_range_id)
  end
end
