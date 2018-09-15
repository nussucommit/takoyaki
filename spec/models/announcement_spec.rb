# frozen_string_literal: true
# == Schema Information
#
# Table name: announcements
#
#  id         :bigint(8)        not null, primary key
#  subject    :text             not null
#  details    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Announcement, type: :model do
  it 'saves given a valid Announcement' do
    announcement = build(:announcement)
    expect(announcement.save).to be true
  end

  it 'does not save given an Announcement with no subject' do
    announcement = build(:announcement, subject: nil)
    expect(announcement.save).to be false
  end

  it 'does not save given an Announcement with no details' do
    announcement = build(:announcement, subject: nil)
    expect(announcement.save).to be false
  end
end
