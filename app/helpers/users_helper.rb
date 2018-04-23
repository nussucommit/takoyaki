# frozen_string_literal: true

module UsersHelper
  def flash_class(level)
    case level
    when :notice then 'alert-box alert alert-success'
    when :alert then 'alert-box alert alert-danger'
    end
  end
end
