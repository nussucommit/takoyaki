# frozen_string_literal: true

# == Schema Information
#
# Table name: duties
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)
#  timeslot_id     :bigint(8)
#  date            :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  request_user_id :integer
#  free            :boolean          default(FALSE), not null
#
# Indexes
#
#  index_duties_on_date_and_timeslot_id  (date,timeslot_id) UNIQUE
#  index_duties_on_timeslot_id           (timeslot_id)
#  index_duties_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (timeslot_id => timeslots.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Duty, type: :model do
  it { should belong_to(:user).optional }
  it {
    should belong_to(:request_user)
      .class_name('User')
      .optional.inverse_of(:duties)
  }
  it { should belong_to(:timeslot) }
  it { should have_one(:time_range).through(:timeslot) }
  it { should have_one(:place).through(:timeslot) }
  it { should validate_uniqueness_of(:date).scoped_to(:timeslot_id) }

  it 'self.generate works properly' do
    create(:timeslot)
    expect(Timeslot.count).to eq(1)
    expect do
      Duty.generate(Time.zone.today.beginning_of_week, Time.zone.today)
    end
      .to change { Duty.where(date: Time.zone.today.beginning_of_week).count }
      .by(1)
  end

  it 'ordered_by_start_time' do
    create_list(:time_range, 10)

    today = Time.zone.today
    Duty.generate(today.beginning_of_week, today)
    expect(
      Duty.where(date: today.beginning_of_week).ordered_by_start_time
          .each_cons(2).all? { |a, b| a < b }
    ).to be(true)
  end
end
