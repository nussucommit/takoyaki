# frozen_string_literal: true

# == Schema Information
#
# Table name: problem_reports
#
#  id                  :bigint(8)        not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  computer_number     :string           not null
#  description         :text             not null
#  is_critical         :boolean
#  is_fixed            :boolean          default(FALSE), not null
#  is_fixable          :boolean          default(TRUE), not null
#  remarks             :text
#  place_id            :integer
#  is_blocked          :boolean          default(FALSE), not null
#  reporter_user_id    :integer
#  last_update_user_id :integer
#
# Foreign Keys
#
#  fk_rails_...  (last_update_user_id => users.id)
#  fk_rails_...  (place_id => places.id)
#  fk_rails_...  (reporter_user_id => users.id)
#

class ProblemReport < ApplicationRecord
  validates :computer_number, presence: true
  validates :description, presence: true
  belongs_to :reporter_user, class_name: 'User', optional: true,
                             inverse_of: :reported_problem_reports
  belongs_to :last_update_user, class_name: 'User', optional: true,
                                inverse_of: :last_updated_problem_reports
  belongs_to :place
end
