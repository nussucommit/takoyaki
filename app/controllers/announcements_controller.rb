# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  def index
  	@announcements = Announcement.all
  end

  # show
  def show
  	@announcement = Announcement.find params[:id]
  end

  # new

  def create
    announcement = Announcement.new announcement_new_params
    announcement.date = DateTime.now

    if announcement.save
      redirect_to announcements_path
    end
  end

  private
    def announcement_new_params
      params.require(:announcement).permit(:subject, :details)
    end
end
