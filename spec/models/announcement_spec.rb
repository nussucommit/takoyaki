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

require 'rails_helper'

RSpec.describe Announcement, type: :model do
  it 'saves given a valid Announcement' do
    announcement = FactoryBot.build(:announcement)
    expect(announcement.save).to be true
  end

  it 'does not save given an Announcement with no subject' do
    announcement = FactoryBot.build(:invalid_subject)
    expect(announcement.save).to be false
  end

  it 'does not save given an Announcement with no details' do
    announcement = FactoryBot.build(:invalid_details)
    expect(announcement.save).to be false
  end
end
