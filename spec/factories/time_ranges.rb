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
# rubocop:enable Metrics/LineLength

FactoryBot.define do
  factory :time_range do
    start_time '2018-01-31 20:11:16'
    end_time '2018-01-31 20:11:16'
  end
end
