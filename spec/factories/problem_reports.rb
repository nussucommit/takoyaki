# frozen_string_literal: true
# == Schema Information
#
# Table name: problem_reports
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  computer_number     :string
#  description         :text
#  is_critical         :boolean
#  is_fixed            :boolean
#  is_fixable          :boolean
#  remarks             :text
#  place_id            :integer
#  is_blocked          :boolean
#  reporter_user_id    :integer
#  last_update_user_id :integer
#
# Foreign Keys
#
#  fk_rails_...  (last_update_user_id => users.id)
#  fk_rails_...  (place_id => places.id)
#  fk_rails_...  (reporter_user_id => users.id)
#

FactoryBot.define do
  factory :problem_report do
    association :reporter_user, factory: :user
    association :last_update_user, factory: :user
    place factory: :place
    computer_number 'A10'
    description 'Desc'
  end
end
