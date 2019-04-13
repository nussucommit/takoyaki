# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  matric_num             :string
#  contact_num            :string
#  cell                   :integer          not null
#  mc                     :boolean          default(FALSE), not null
#  receive_email          :boolean          default(TRUE), not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:duties).dependent(:nullify) }
  it {
    should have_many(:timeslots).with_foreign_key(:default_user_id)
      .inverse_of(:default_user).dependent(:nullify)
  }
  it {
    should have_many(:reported_problem_reports).class_name('ProblemReport')
      .with_foreign_key('reporter_user_id').inverse_of(:reporter_user)
                                               .dependent(:nullify)
  }
  it {
    should have_many(:last_updated_problem_reports).class_name('ProblemReport')
      .with_foreign_key(:last_update_user_id).inverse_of(:last_update_user)
                                                   .dependent(:nullify)
  }
  it { should have_many(:availabilities).dependent(:destroy) }
  it { should validate_presence_of(:cell) }
  it { should validate_presence_of(:email) }
  subject { create(:user) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_uniqueness_of(:username) }
  it { should define_enum_for(:cell).with_values(User::CELLS) }
  it 'has false as default value for mc' do
    expect(create(:user).mc).to eq(false)
  end
end
