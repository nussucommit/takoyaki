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

  scope :duties_at_timeslot,
        lambda { |timeslot|
          joins(:timeslot)
            .where(timeslots: {
                     time_range_id: timeslot.time_range_id
                   })
        }

  scope :duties_at_timeslot_other_place,
        lambda { |timeslot|
          duties_at_timeslot(timeslot)
            .where.not(timeslots: {
                         place_id: timeslot.place_id
                       })
        }

  # To check someone is on_duty at other place
  # @param  user_id
  def user_on_duty?(user_id)
    # reduce query if nil
    return false if user_id.nil?

    Duty.duties_at_timeslot_other_place(timeslot).exists?(user_id: user_id)
  end

  def self.generate(start_date, end_date)
    (start_date..end_date).each do |date|
      day = Date::DAYNAMES[date.wday]
      Timeslot.where(day: day).find_each do |ts|
        duty = Duty.find_or_create_by(timeslot: ts, date: date)
        duty.user = ts.default_user
        duty.save
      end
    end
  end
end
