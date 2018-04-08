# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  def index
    @announcements = Announcement.order(created_at: :desc)
  end

  def create
    announcement = Announcement.new announcement_params

    redirect_to duties_path if announcement.save
  end

  def update
    announcement = Announcement.find params[:id]

    redirect_to duties_path if announcement.update announcement_params
  end

  def destroy
    announcement = Announcement.find params[:id]

    redirect_to duties_path if announcement.destroy
  end

  private

  def announcement_params
    params.require(:announcement).permit(:subject, :details)
  end
end
