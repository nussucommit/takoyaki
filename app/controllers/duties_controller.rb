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
    @drop_duty_list = Duty.find(params[:drop_duty_list])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def open_grab_modal
    @grab_duty_list = Duty.find(params[:grab_duty_list])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def grab
    params[:duty_id]&.each do |duty_id|
      grab_duty = Duty.find(duty_id)
      grab_duty.update(user: current_user, free: false, request_user_id: nil)
    end

    redirect_to duties_path
  end

  def drop
    params[:duty_id].each do |duty_id|
      drop_duty = Duty.find(duty_id)
      swap_user(params[:user_id].to_i, drop_duty)
    end
    redirect_to duties_path
  end

  private

  def swap_user(swap_user_id, drop_duty)
    if swap_user_id.zero?
      drop_duty.update(free: true)
      GenericMailer.drop_duty(drop_duty, User.all)
    else
      drop_duty.update(request_user_id: swap_user_id)
      GenericMailer.drop_duty(drop_duty, User.find(swap_user_id))
    end
  end

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
