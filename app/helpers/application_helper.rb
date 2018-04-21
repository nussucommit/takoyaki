# frozen_string_literal: true

module ApplicationHelper
  def calc_colspan(start_time, end_time)
    ((end_time - start_time) / 0.5.hours).round
  end
  
  def flash_class(level)
    case level
    when :notice then 'alert alert-success'
    when :alert then 'alert alert-danger'
    end
  end
end
