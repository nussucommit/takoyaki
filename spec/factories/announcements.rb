# frozen_string_literal: true
# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  subject    :text             not null
#  details    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :announcement do |a|
    a.subject 'MyText'
    a.details 'MyText'
  end

  factory :invalid_subject, class: Announcement do
  	subject nil
  	details 'Invalid Subject'
  end

  factory :invalid_details, class: Announcement do
  	subject 'Invalid Details'
  	details nil
  end
end
