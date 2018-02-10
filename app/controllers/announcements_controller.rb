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
    announcement.date = DateTime.now.getlocal

    redirect_to announcements_path if announcement.save
  end

  # edit
  def update
    announcement = Announcement.find params[:id]

    redirect_to announcements_path if announcement.update announcement_edit_params
  end

  # delete
  def destroy
    announcement = Announcement.find params[:id]

    redirect_to announcements_path if announcement.destroy
  end

  private

  def announcement_new_params
    params.require(:announcement).permit(:subject, :details)
  end

  def announcement_edit_params
    params.require(:announcement).permit(:subject, :details)
  end
end
