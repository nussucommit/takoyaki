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
      cur = []
      for time_range in time_ranges do
        tmp = Availability.where(user_id: current_user.id, time_range_id: time_range.id, day: day)[0]
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
    tmp.user_id = current_user.id
    tmp.day = day
    tmp.time_range_id = time_range_id
    tmp.status = 0
    tmp.save
    tmp
  end

  def create

    @availabilities = []
    time_ranges = TimeRange.all
    for day in 0..6 do
      cur = []
      for time_range in time_ranges do
        tmp = Availability.where(user_id: current_user.id, time_range_id: time_range.id, day: day)[0]
        if tmp.nil?
          tmp = create_new_availability(time_range.id, day)
        end
        cur.push(tmp)
      end
      @availabilities.push(cur)
    end

    for i in @availabilities do
      for j in i do
        if params[:availability_ids].include? j.id.to_s
          set(j, 1)
        else
          set(j, 0)
        end
      end
    end
  end

  def set(x, y)
    x.status = y
    x.save
  end


end
