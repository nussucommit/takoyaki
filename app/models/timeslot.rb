# frozen_string_literal: true

# == Schema Information
#
# Table name: timeslots
#
#  id              :integer          not null, primary key
#  mc_only         :boolean
#  day             :date
#  default_user_id :integer
#  time_range_id   :integer
#  place_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
  belongs_to :default_user, class_name: 'User', inverse_of: :timeslots
  belongs_to :place
  belongs_to :time_range
end
