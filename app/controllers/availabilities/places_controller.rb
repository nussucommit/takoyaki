# frozen_string_literal: true

module Availabilities
  class PlacesController < ApplicationController
    def index
      @places = Place.all
    end

    def edit
      @users = User.all
      @place = Place.find(params[:id])
      load_availabilities
      @time_ranges = TimeRange.order(:start_time)
      @time_ranges_map = load_timeranges_map
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

    def load_timeranges_map
      Hash[TimeRange.all.map do |time_range|
             [time_range.start_time, time_range]
           end
      ]
    end

    def update_timeslot(timeslot)
      selected_user_id = params["#{Availability.days[timeslot.day]}" \
                                "#{timeslot.time_range_id}"]
      return if timeslot.default_user_id.to_s == selected_user_id.to_s
      timeslot.update(default_user_id: selected_user_id)
    end

    def load_availabilities
      @availabilities = Hash.new { |h, k| h[k] = Set[] }
      Availability.where(status: true).each do |a|
        @availabilities[
          [Availability.days[a.day], a.time_range_id]] << a.user_id
      end
    end
  end
end
