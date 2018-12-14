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

class Setting < ApplicationRecord
  before_create :only_one_row

  def self.retrieve
    Setting.first || Setting.create
  end

  private

  def only_one_row
    return true if Setting.count.zero?

    errors.add(:base, 'There can only be 1 row')
    throw :abort
  end
end
