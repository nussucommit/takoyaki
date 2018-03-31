# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string
#  resource_type :string
#  resource_id   :integer
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
  it { should validate_inclusion_of(:name).in_array(Role::ROLES.map(&:to_s)) }
  it {
    should validate_inclusion_of(:resource_type)
      .in_array(Rolify.resource_types).allow_nil
  }
  it { should belong_to(:resource) }
  it { should have_and_belong_to_many(:users).join_table('users_roles') }
end
