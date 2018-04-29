# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
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
#  index_duties_on_timeslot_id                       (timeslot_id)
#  index_duties_on_user_id                           (user_id)
#  index_duties_on_user_id_and_timeslot_id_and_date  (user_id,timeslot_id,date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (timeslot_id => timeslots.id)
#  fk_rails_...  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryBot.define do
  factory :duty do
    user nil
    timeslot
    date '2018-01-31'
  end
end
