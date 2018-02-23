# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  def index
    @announcements = Announcement.all
    @new_announcements = Announcement.new
  end

  def show
    @announcement = Announcement.find params[:id]
  end

  def create
    announcement = Announcement.new announcement_params
    announcement.date = Time.zone.now

    redirect_to announcements_path if announcement.save
  end

  def update
    announcement = Announcement.find params[:id]

    redirect_to announcements_path if announcement.update announcement_params
  end

  def destroy
    announcement = Announcement.find params[:id]

    redirect_to announcements_path if announcement.destroy
  end

  private

  def announcement_params
    params.require(:announcement).permit(:subject, :details)
  end
end
