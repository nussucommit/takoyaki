# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    @duties = Duty.all
    tr = TimeRange.all.sort_by(&:start_time)
    @first = tr.first.start_time
    @last = tr.last.end_time
    @Timeslot = Timeslot.all
  end
end
