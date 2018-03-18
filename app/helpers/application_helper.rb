# frozen_string_literal: true

module ApplicationHelper
  def calc_colspan(start_time, end_time)
    ((end_time - start_time) / 0.5.hours).round
  end
end
