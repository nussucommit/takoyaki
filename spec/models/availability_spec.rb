# frozen_string_literal: true

# == Schema Information
#
# Table name: availabilities
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  day           :integer
#  time_range_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :integer
#
# Indexes
#
#  index_availabilities_on_time_range_id  (time_range_id)
#  index_availabilities_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (time_range_id => time_ranges.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Availability, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:time_range) }
  it 'saves given a valid Availability' do
    create(:time_range)
    create(:user)
    availability = Availability.new(user_id: User.take.id, time_range_id: TimeRange.take.id, status: 1, day: 6)
    expect(availability.save).to be true
    availability = Availability.new(user_id: User.take.id, time_range_id: TimeRange.take.id, status: "Available", day: "Monday")
    expect(availability.save).to be true
  end
  it 'raises ArgumentError if day is out of range' do
    create(:time_range)
    create(:user)
    expect { Availability.new(user_id: User.take.id, time_range_id: TimeRange.take.id, status: 1, day: 7) }.to raise_error(ArgumentError)
    expect { Availability.new(user_id: User.take.id, time_range_id: TimeRange.take.id, status: 1, day: -1) }.to raise_error(ArgumentError)
    expect { Availability.new(user_id: User.take.id, time_range_id: TimeRange.take.id, status: 1, day: 0.5) }.to raise_error(ArgumentError)
    expect { Availability.new(user_id: User.take.id, time_range_id: TimeRange.take.id, status: 1, day: "takoyaki") }.to raise_error(ArgumentError)
  end
  it 'raises ArgumentError if status is out of range' do
    create(:time_range)
    create(:user)
    expect { Availability.new(user_id: User.take.id, time_range_id: TimeRange.take.id, status: -1, day: 6) }.to raise_error(ArgumentError)
    expect { Availability.new(user_id: User.take.id, time_range_id: TimeRange.take.id, status: 2, day: 6) }.to raise_error(ArgumentError)
  end
  it 'does not save if User does not exist' do
    create(:time_range)
    availability = Availability.new(user_id: 1, time_range_id: TimeRange.take.id, status: 1, day: 6)
    expect(availability.save).to be false
    availability = Availability.new(user_id: nil, time_range_id: TimeRange.take.id, status: 1, day: 6)
    expect(availability.save).to be false
  end
  it 'does not save if TimeRange does not exist' do
    create(:user)
    availability = Availability.new(user_id: User.take.id, time_range_id: 1, status: 1, day: 6)
    expect(availability.save).to be false
    availability = Availability.new(user_id: User.take.id, time_range_id: nil, status: 1, day: 6)
    expect(availability.save).to be false
  end
end
