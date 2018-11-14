# frozen_string_literal: true

# == Schema Information
#
# Table name: time_ranges
#
#  id         :bigint(8)        not null, primary key
#  start_time :time
#  end_time   :time
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TimeRange < ApplicationRecord
end
