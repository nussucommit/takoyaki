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
#  is_blocked          :boolean
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

require 'rails_helper'

RSpec.describe ProblemReport, type: :model do
  it { should belong_to(:reporter_user) }
  it { should belong_to(:last_update_user) }
  it { should belong_to(:place) }
  
  it "saves a valid Problem Report" do
    expect(create(:problem_report)).to be_valid
  end
  
  it "does not save if there is no description/computer number" do
    expect(build(:problem_report, description: "").save).to be false
    expect(build(:problem_report, computer_number: "").save).to be false
  end
end
