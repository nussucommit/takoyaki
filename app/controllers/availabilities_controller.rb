class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!
  def index
    if user_signed_in?

    else
      redirect_to new_user_session_path
    end
    @availabilities = []
    time_ranges = TimeRange.all
    for day in 0..6 do
      puts day
      cur = []
      for time_range in time_ranges do
        tmp = Availability.where(user_id: 1, time_range_id: time_range.id, day: day)[0]
        if tmp.nil?
          tmp = create_new_availability(time_range.id, day)
        end
        cur.push(tmp)
      end
      @availabilities.push(cur)
    end
  end

  def create_new_availability(time_range_id, day)
    tmp = Availability.new
    tmp.user_id = 1
    tmp.day = day
    tmp.time_range_id = time_range_id
    tmp.status = 0
    if tmp.save
    else
      puts 'fail'
    end
    tmp
  end

end
