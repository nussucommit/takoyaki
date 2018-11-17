# frozen_string_literal: true

# == Schema Information
#
# Table name: timeslots
#
#  id              :bigint(8)        not null, primary key
#  mc_only         :boolean
#  default_user_id :bigint(8)
#  time_range_id   :bigint(8)
#  place_id        :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  day             :integer
#
# Indexes
#
#  index_timeslots_on_default_user_id  (default_user_id)
#  index_timeslots_on_place_id         (place_id)
#  index_timeslots_on_time_range_id    (time_range_id)
#
# Foreign Keys
#
#  fk_rails_...  (default_user_id => users.id)
#  fk_rails_...  (place_id => places.id)
#  fk_rails_...  (time_range_id => time_ranges.id)
#

FactoryBot.define do
  factory :timeslot do
    mc_only { false }
    day { Date::DAYNAMES[1] }
    association :default_user, factory: :user
    time_range
    place
  end
end
