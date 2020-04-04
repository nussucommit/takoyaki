# frozen_string_literal: true

module Duties
  class PlacesController < ApplicationController
    load_and_authorize_resource
    before_action :authenticate_user!

    def index
      set_start_end_dates
    end

    def edit
      set_start_end_dates
      @users = User.order(:username)
      load_availabilities
      load_timeslots
      @disable_viewport = true
    end

    def update
      message = []
      duty_params.each do |id, user_id|
        duty = Duty.find(id)
        timeslot = duty.timeslot
        user_on_duty = Duty.joins(:timeslot)
                           .where(timeslots: { time_range_id: timeslot.time_range_id })
                           .where.not(timeslots: { place_id: timeslot.place_id }).exists?(user_id: user_id)
        if duty.free || user_on_duty
          message.push("#{User.find(user_id).username} is on duty")
        else
          duty.update(user_id: user_id, free: false, request_user: nil)
        end
      end
      start_of_week = Duty.find(duty_params.keys.first).date.beginning_of_week
      if message.size
        redirect_to(edit_duties_place_path(@place, start_date: start_of_week),
                    alert: message.join("\n")) && return
      end
      redirect_to edit_duties_place_path(@place, start_date: start_of_week),
                  notice: 'Duties successfully updated!'
    end

    private

    def load_availabilities
      @availabilities = Hash.new { |h, k| h[k] = Set[] }
      Availability.where(status: true).each do |a|
        @availabilities[
          [Availability.days[a.day], a.time_range_id]] << a.user_id
      end
    end

    def load_timeslots
      @timeslots = Hash.new { |h, k| h[k] = [] }
      Timeslot.where(place_id: params[:id]).includes(:time_range)
              .each do |timeslot|
        @timeslots[Availability.days[timeslot.day]] << timeslot
      end
    end

    def duty_params
      params.require(:duty)
    end
  end
end
