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
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:details) }
end
