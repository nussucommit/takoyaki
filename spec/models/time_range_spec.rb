# frozen_string_literal: true

# == Schema Information
#
# Table name: time_ranges
#
#  id         :integer          not null, primary key
#  start_time :time
#  end_time   :time
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe TimeRange, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
