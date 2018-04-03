# frozen_string_literal: true

module Availabilities
  class PlacesController < ApplicationController
    def index
      @places = Place.all
    end

    def edit
      @place = Place.find(params[:id])
      @time_ranges = TimeRange.order(:start_time)
      @timeslots = Hash[Timeslot.joins(:time_range)
                                .map do |timeslot|
                          [[Availability.days[timeslot.day], timeslot.time_range_id], timeslot]
                        end
      ]
      @start_time = start_time
      @end_time = end_time
    end

    def update; end

    private


    def start_time
      @time_ranges.first.start_time.beginning_of_hour
    end

    def end_time
      (@time_ranges.last.end_time - 1).beginning_of_hour + 1.hour
    end

  end
end
