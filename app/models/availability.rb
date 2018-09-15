# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: availabilities
#
#  id            :bigint(8)        not null, primary key
#  user_id       :bigint(8)
#  day           :integer          not null
#  time_range_id :bigint(8)
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

class Availability < ApplicationRecord
  belongs_to :user
  belongs_to :time_range
  enum day: Date::DAYNAMES
end
