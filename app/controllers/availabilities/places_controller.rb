# frozen_string_literal: true

module Availabilities
  class PlacesController < ApplicationController
    def index
      @time_ranges = TimeRange.order(:start_time)
      @timeslots = Hash[Timeslot.joins(:time_range)
                                .map do |timeslot|
                          [[timeslot.day, timeslot.time_range_id], timeslot]
                        end
      ]
    end

    def edit; end

    def update; end
  end
end
