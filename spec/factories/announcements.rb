# frozen_string_literal: true
# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  date       :datetime
#  subject    :text
#  details    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :announcement do
    date '2018-02-03 14:37:02'
    user nil
    subject 'MyText'
    details 'MyText'
  end
end
