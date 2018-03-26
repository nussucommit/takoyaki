# == Schema Information
#
# Table name: problem_reports
#
#  id                  :integer          not null, primary key
#  reporter_user_id    :integer
#  last_update_user_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  venue               :string
#  computer_number     :string
#  description         :string
#  is_critical         :boolean
#  is_fixed            :boolean
#  is_fixable          :boolean
#  remarks             :string
#
# Indexes
#
#  index_problem_reports_on_last_update_user_id  (last_update_user_id)
#  index_problem_reports_on_reporter_user_id     (reporter_user_id)
#

FactoryBot.define do
  factory :problem_report do
    reporter_user ""
    last_update_user ""
  end
end
