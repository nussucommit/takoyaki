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

require 'rails_helper'

RSpec.describe Availability, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:time_range) }
  it { should define_enum_for(:day).with(Date::DAYNAMES) }

  it 'saves given a valid Availability' do
    expect(create(:availability)).to be_valid
  end
  it 'raises ArgumentError if day is out of range' do
    expect { create(:availability, day: 7) }.to raise_error(ArgumentError)
    expect { create(:availability, day: -1) }.to raise_error(ArgumentError)
    expect { create(:availability, day: 0.5) }.to raise_error(ArgumentError)
    expect { create(:availability, day: '1') }.to raise_error(ArgumentError)
  end
  it 'does not save if User does not exist' do
    expect(build(:availability, user_id: nil).save).to be false
    expect(build(:availability, user_id: User.maximum(:id).to_i.next).save)
      .to be false
  end
  it 'does not save if TimeRange does not exist' do
    expect(build(:availability, time_range_id: nil).save).to be false
    expect(build(:availability, time_range_id: TimeRange.maximum(:id).to_i.next)
      .save).to be false
  end
end
