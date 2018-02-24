# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    time_range = TimeRange.order(:start_time)
    @first = time_range.first.start_time
    @last = time_range.last.end_time
  end
end
