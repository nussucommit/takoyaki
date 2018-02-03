# rubocop:disable Metrics/LineLength
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

class Announcement < ApplicationRecord
  belongs_to :user
end
