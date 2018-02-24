# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
  end

  def generate
    start_date = Time.zone.today.beginning_of_week
    end_date = start_date + (7 * params[:num_weeks].to_i).day 
    (start_date..end_date).each do |date| 
      day = Date::DAYNAMES[date.wday]
      Timeslot.where(day: day).each do |ts|
        default_user = User.find_by(id: ts.default_user_id)
        Duty.find_by_or_create(user: default_user, timeslot: ts, date: date)
      end
    end
    redirect_to duties_path
  end
end
