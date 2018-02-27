# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    time_range = TimeRange.order(:start_time)
    first = time_range.first.start_time
    @header_iter = first.to_i.step(time_range.last.start_time.to_i, 3600)
    # upper-bound exclusive, hence subtract by 1
    @timetable_iter = first.to_i.step(time_range.last.end_time.to_i - 1, 1800)
  end
end
