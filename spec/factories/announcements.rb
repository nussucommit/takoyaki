# frozen_string_literal: true

# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  date       :datetime
#  user_id    :integer
#  subject    :text
#  details    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_announcements_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryBot.define do
  factory :announcement do
    date '2018-02-03 14:37:02'
    user nil
    subject 'MyText'
    details 'MyText'
  end
end
