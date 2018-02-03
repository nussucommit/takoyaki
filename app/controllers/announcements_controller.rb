class AnnouncementsController < ApplicationController
	def new 
		@announcements = Announcement.new
		@users = User.all
	end

end
