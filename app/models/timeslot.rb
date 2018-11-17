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

class Timeslot < ApplicationRecord
  has_many :duties, dependent: :destroy
  belongs_to :default_user, class_name: 'User', inverse_of: :timeslots,
                            optional: true
  belongs_to :place
  belongs_to :time_range
  enum day: Date::DAYNAMES
end
