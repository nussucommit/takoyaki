# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    @header_iter = generate_header_iter
    @start_date = (params[:start_date] || Time.zone.today.beginning_of_week)
                  .to_date
    @end_date = @start_date.to_date + 6.days
    @places = Place.all
    prepare_announcements
  end

  def generate_duties
    start_date = Time.zone.today.beginning_of_week
    end_date = start_date + (params[:num_weeks].to_i * 7 - 1).days
    Duty.generate(start_date, end_date)
    redirect_to duties_path
  end

  def open_drop_modal
    @users = User.where.not(id: current_user.id)
    @drop_duty_list = params[:drop_duty_list].map do |id|
      Duty.find_by(id: id)
    end
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def grab
    grab_duty = Duty.find_by(id: params[:grab_duty])
    grab_duty.update(user: current_user, free: false, request_user_id: nil)
    grab_duty.save
    redirect_to duties_path
  end
  
  def drop
    drop_array = params[:duty_id]
    swap_user_id = params[:user_id].to_i
    drop_array.each_with_index do |duty_id, index|
      drop_duty_id = drop_array[index].to_i
      drop_duty = Duty.find_by(id: drop_duty_id)
      if swap_user_id == 0
        drop_duty.update(free: true)
      else 
        drop_duty.update(request_user_id: swap_user_id)
      end
    end
    redirect_to duties_path 
  end


  private

  def generate_header_iter

    time_range = TimeRange.order(:start_time)
    first_time = time_range.first.start_time
    last_time = time_range.last.start_time
    first_time.to_i.step(last_time.to_i, 1.hour)
  end

  def prepare_announcements
    @announcements = Announcement.order(created_at: :desc).limit(3)
    @new_announcement = Announcement.new
  end
end
