# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: availabilities
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  day           :integer          not null
#  time_range_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :boolean          not null
#
# Indexes
#
#  index_availabilities_on_time_range_id                      (time_range_id)
#  index_availabilities_on_user_id                            (user_id)
#  index_availabilities_on_user_id_and_time_range_id_and_day  (user_id,time_range_id,day) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (time_range_id => time_ranges.id)
#  fk_rails_...  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryBot.define do
  factory :availability do
    association :user, factory: :user
    association :time_range, factory: :time_range
    day 1
    status 1
  end
end
