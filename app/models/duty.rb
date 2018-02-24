# frozen_string_literal: true

# == Schema Information
#
# Table name: duties
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  timeslot_id :integer
#  date        :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_duties_on_timeslot_id  (timeslot_id)
#  index_duties_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (timeslot_id => timeslots.id)
#  fk_rails_...  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class Duty < ApplicationRecord
  belongs_to :user
  belongs_to :timeslot
  #validates_uniqueness_of :date, scope = [:timeslot_id, :user_id]

  def generate(start_date, end_date)
    (start_date..end_date).each do |date| 
      day = Date::DAYNAMES[date.wday]
      Timeslot.where(day: day).each do |ts|
        default_user = User.find_by(id: ts.default_user_id)
        Duty.find_by_or_create(user: default_user, timeslot: ts, date: date)
      end
    end
    redirect_to duties_path
  end

end
