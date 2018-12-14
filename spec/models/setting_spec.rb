# frozen_string_literal: true

# == Schema Information
#
# Table name: settings
#
#  id         :bigint(8)        not null, primary key
#  mc_only    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Setting, type: :model do
  it 'only allows 1 row' do
    rand(2..10).times.each { Setting.create }
    expect(Setting.count).to be(1)
  end

  it 'creates row when empty' do
    expect(Setting.count).to be(0)
    Setting.retrieve
    expect(Setting.count).to be(1)
    Setting.retrieve
    expect(Setting.count).to be(1)
  end
end
