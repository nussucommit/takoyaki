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
  
  def grab
    @duty = Duty.find params[:id]
    @duty.user=current_user
    @duty.save
    redirect_to duties_path
  end
  
  def drop
    @duty = Duty.find params[:id]
    @duty.user = nil
    @duty.save
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
