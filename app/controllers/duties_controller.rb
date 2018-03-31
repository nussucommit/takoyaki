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
    grab_duty.update(user: current_user, free: false)
    grab_duty.save
    redirect_to duties_path
  end
  
  def drop
    Duty.where(id: params[:duty_id]).update_all(free: true)
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
