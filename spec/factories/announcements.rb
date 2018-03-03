# frozen_string_literal: true
# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  subject    :text
#  details    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :announcement do |a|
    a.subject 'MyText'
    a.details 'MyText'
  end
end
