# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  matric_num             :string
#  contact_num            :string
#  cell                   :integer          not null
#  mc                     :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:duties) }
  it { should have_many(:timeslots).with_foreign_key(:default_user_id) }
  it { should validate_presence_of(:cell) }
  it { should define_enum_for(:cell).with(User::CELLS) }
  it 'has false as default value for mc' do
    expect(create(:user).mc).to eq(false)
  end
end
