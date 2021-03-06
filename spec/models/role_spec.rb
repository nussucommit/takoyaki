# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: roles
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  resource_type :string
#  resource_id   :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  index_roles_on_resource_type_and_resource_id           (resource_type,resource_id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Role, type: :model do
  it { should belong_to(:resource).optional }
  it {
    should validate_inclusion_of(:resource_type)
      .in_array(Rolify.resource_types)
  }
end
