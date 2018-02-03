# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  def index
  	@announcements = Announcement.all
  end

  def show
  	@announcement = Announcement.find params[:id]
  end

  def new
    @announcements = Announcement.new
    @users = User.all
  end
end
