# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    @header_iter = generate_header_iter
    set_start_end_dates
    # Eager load all rows in Place
    @places = Place.all.map { |p| p }
    prepare_announcements
  end

  def generate_duties
    set_start_end_dates
    end_date = @start_date + (params[:num_weeks].to_i * 7 - 1).days
    Duty.generate(@start_date, end_date)
    redirect_to duties_path(start_date: @start_date),
                notice: 'Duties successfully generated!'
  end

  def open_drop_modal
    @users = User.where.not(id: current_user.id).order(:username)
    @drop_duty_list = Duty.includes(timeslot: %i[time_range place])
                          .find(params[:drop_duty_list])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def open_grab_modal
    @grab_duty_list = Duty.includes(timeslot: %i[time_range place])
                          .find(params[:grab_duty_list])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def grab
    if grabable?(params[:duty_id])
      Duty.find(params[:duty_id].keys).each do |duty|
        duty.update(user: current_user, free: false, request_user: nil)
      end
      redirect_to duties_path, notice: 'Duty successfully grabbed!'
    else
      redirect_to duties_path, alert: 'Invalid duties to grab'
    end
  end

  def drop
    if owned_duties?(params[:duty_id], current_user)
      drop_duty_ids = params[:duty_id].keys
      if can_drop_duties?(drop_duty_ids)
        swap_user(drop_duty_ids, params[:user_id])
        redirect_to duties_path, notice: 'Duty successfully dropped!'
      else
        redirect_to duties_path, alert: 'Error in dropping duty! ' \
          'You can only drop your duty at most 2 hours before it starts'
      end
    else
      redirect_to duties_path, alert: 'Invalid duties to drop'
    end
  end

  def show_grabable_duties
    @grabable_duties = grabable_duties
  end

  private

  def grabable_duties
    Duty.includes(timeslot: %i[time_range place])
        .where('free = true or request_user_id = ? or
                                  request_user_id IS NOT NULL and user_id = ?',
               current_user.id, current_user.id)
        .select do |d|
      Time.zone.now < (d.date +
                       d.time_range.start_time.seconds_since_midnight.seconds)
    end
  end

  def owned_duties?(duty_id_params, supposed_user)
    duty_id_params.present? &&
      Duty.where('id IN (?) AND user_id = ?',
                 duty_id_params.keys, supposed_user.id)
          .count == duty_id_params.keys.length
  end

  def grabable?(duty_id_params)
    duty_id_params.present? && duty_id_params.keys.all? do |d|
      duty = Duty.find(d)
      duty.free || duty.request_user == current_user ||
        (duty.request_user.present? && duty.user == current_user)
    end
  end

  def can_drop_duties?(drop_duty_ids)
    duties = duties_sorted_by_start_time(drop_duty_ids)
    duty_date = duties.first.date
    duty_start_time = duties.first.time_range.start_time
    duty_datetime = duty_date + duty_start_time.seconds_since_midnight.seconds
    Time.zone.now <= (duty_datetime - 2.hours)
  end

  def swap_user(drop_duty_ids, swap_user_id)
    duties = duties_sorted_by_start_time(drop_duty_ids)
    to_all = swap_user_id.to_i.zero?
    Duty.transaction do
      if to_all
        duties.each { |duty| duty.update(free: true) }
      else
        duties.each { |duty| duty.update(request_user_id: swap_user_id) }
      end
    end
    users_to_notify =
      to_all ? User.pluck(:id) - [duties.first.user.id] : swap_user_id
    GenericMailer.drop_duties(duties, users_to_notify).deliver_later
  end

  def duties_sorted_by_start_time(duty_ids)
    Duty.joins(timeslot: :time_range).order('time_ranges.start_time ASC')
        .includes(timeslot: :time_range).find(duty_ids)
  end

  def generate_header_iter
    time_range = TimeRange.order(:start_time)
    @first_time = time_range.first.start_time
    @last_time = time_range.last.start_time
    @first_time.to_i.step(@last_time.to_i, 1.hour)
  end

  def prepare_announcements
    @announcements = Announcement.order(created_at: :desc).limit(3)
    @new_announcement = Announcement.new
  end
end
