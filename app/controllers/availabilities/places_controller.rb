# frozen_string_literal: true

module Availabilities
  class PlacesController < ApplicationController
    def index
      @places = Place.all
    end

    def edit
      @users = User.all
      @place = Place.find(params[:id])
      @time_ranges = TimeRange.order(:start_time)
      @timeslots = load_timeslots
      @start_time = start_time
      @end_time = end_time
    end

    def update
      Timeslot.where(place_id: params[:id]).each do |timeslot|
        update_timeslot(timeslot)
      end
      redirect_to edit_availabilities_place_path(id: params[:id])
    end

    private

    def start_time
      @time_ranges.first.start_time.beginning_of_hour
    end

    def end_time
      (@time_ranges.last.end_time - 1).beginning_of_hour + 1.hour
    end

    def load_timeslots
      Hash[Timeslot.where(place_id: params[:id]).joins(:time_range)
                   .map do |timeslot|
             [[Availability.days[timeslot.day],
               timeslot.time_range_id], timeslot]
           end
      ]
    end

    def update_timeslot(timeslot)
      selected_user_id = params["#{Availability.days[timeslot.day]}" \
                                "#{timeslot.time_range_id}"]
      return if timeslot.default_user_id.to_s == selected_user_id.to_s
      timeslot.update(default_user_id: selected_user_id)
    end
  end
end
