# frozen_string_literal: true

module Availabilities
  class PlacesController < ApplicationController
    def index
      @places = Place.all
    end

    def edit
      @time_ranges = TimeRange.order(:start_time)
      @timeslots = Hash[Timeslot.joins(:time_range)
                                .map do |timeslot|
                          [[timeslot.day, timeslot.time_range_id], timeslot]
                        end
      ]
    end

    def update; end
  end
end
