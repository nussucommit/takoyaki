# frozen_string_literal: true

# == Schema Information
#
# Table name: problem_reports
#
#  id                  :integer          not null, primary key
#  reporter_user_id    :integer
#  last_update_user_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  computer_number     :string
#  description         :text
#  is_critical         :boolean
#  is_fixed            :boolean
#  is_fixable          :boolean
#  remarks             :text
#  place_id            :integer
#
# Indexes
#
#  index_problem_reports_on_last_update_user_id  (last_update_user_id)
#  index_problem_reports_on_reporter_user_id     (reporter_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (place_id => places.id)
#

class ProblemReport < ApplicationRecord
  belongs_to :reporter_user, class_name: 'User', inverse_of: :problem_report
  belongs_to :last_update_user, class_name: 'User', inverse_of: :problem_report
  belongs_to :place
end
