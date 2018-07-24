# frozen_string_literal: true

# == Schema Information
#
# Table name: duties
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  timeslot_id     :integer
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

class Duty < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :request_user, class_name: 'User', optional: true,
                            inverse_of: :duties
  belongs_to :timeslot
  has_one :time_range, through: :timeslot
  has_one :place, through: :timeslot
  validates :date, uniqueness: { scope: :timeslot_id }
  scope :ordered_by_start_time,
        -> { joins(:time_range).order('time_ranges.start_time') }

  def self.generate(start_date, end_date)
    (start_date..end_date).each do |date|
      day = Date::DAYNAMES[date.wday]
      Timeslot.where(day: day).find_each do |ts|
        Duty.find_or_create_by(user: ts.default_user, timeslot: ts, date: date)
      end
    end
  end
end
