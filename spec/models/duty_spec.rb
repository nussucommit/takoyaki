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

require 'rails_helper'

RSpec.describe Duty, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:timeslot) }
end
