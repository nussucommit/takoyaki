# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    @duties = Duty.all
    tr = TimeRange.all.sort_by(&:start_time)
    @first = tr.first.start_time
    @last = tr.last.end_time
    @Timeslot = Timeslot.all
  end

  def generate
    start_date = Time.zone.today.beginning_of_week
    end_date = start_date + (7 * params[:num_weeks].to_i).day 
    (start_date..end_date).each do |date| 
      day = Date::DAYNAMES[date.wday]
      Timeslot.where(day: day).each do |ts|
        default_user = User.find_by(id: ts.default_user_id)
        Duty.create(user: default_user, timeslot: ts, date: date) unless Duty.find_by(user:default_user, timeslot: ts, date: date)
      end
    end
    redirect_to duties_path
  end
end
