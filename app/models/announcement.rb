# frozen_string_literal: true

# == Schema Information
#
# Table name: announcements
#
#  id         :bigint(8)        not null, primary key
#  subject    :text             not null
#  details    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Announcement < ApplicationRecord
  validates :subject, presence: true
  validates :details, presence: true
end

class Post < ActiveRecord::Base
  belongs_to :user
  before_save :check_post_quota

  def check_post_quota
	if self.user.posts.count >=3
		self.errors.add(:base, "You've reached maximum posts you can import")
		return false
	end
  end
end
