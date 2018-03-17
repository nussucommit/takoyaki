# frozen_string_literal: true

# == Schema Information
#
# Table name: time_ranges
#
#  id         :integer          not null, primary key
#  start_time :time
#  end_time   :time
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :time_range do
    sequence(:start_time) { |n| '08:00'.in_time_zone + n.hours }
    sequence(:end_time) { |n| '09:00'.in_time_zone + n.hours }
  end
end
