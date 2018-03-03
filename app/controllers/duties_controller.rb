# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    time_range = TimeRange.order(:start_time)
    first = time_range.first.start_time
    @header_iter = first.to_i.step(time_range.last.start_time.to_i, 3600)
    # upper-bound exclusive, hence subtract by 1
    @timetable_iter = first.to_i.step(time_range.last.end_time.to_i - 1, 1800)
    @start_date = Time.zone.today.beginning_of_week
    @end_date = @start_date + 6.days
    @places = Place.all
    @duty_array = (@start_date..@end_date).to_a.map do |date|
      @places.map do |place|
        Duty.where(date: date)
            .joins(:timeslot).where('timeslots.place' => place)
      end
    end
  end
end
