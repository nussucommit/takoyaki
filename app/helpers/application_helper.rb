# frozen_string_literal: true

module ApplicationHelper
  def calc_colspan(start_time, end_time)
    ((end_time - start_time) / 0.5.hours).round
  end

  def flash_class(level)
    case level
    when :notice then 'alert alert-success alert-dismissible'
    when :alert then 'alert alert-danger alert-dismissible'
    end
  end
end
