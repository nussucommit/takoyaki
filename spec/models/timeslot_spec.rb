# frozen_string_literal: true

# == Schema Information
#
# Table name: timeslots
#
#  id              :integer          not null, primary key
#  mc_only         :boolean
#  default_user_id :integer
#  time_range_id   :integer
#  place_id        :integer
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

require 'rails_helper'

RSpec.describe Timeslot, type: :model do
  it { should have_many(:duties) }
  it { should belong_to(:default_user).class_name('User') }
  it { should belong_to(:place) }
  it { should belong_to(:time_range) }
  it { should define_enum_for(:day).with(Date::DAYNAMES) }
end
