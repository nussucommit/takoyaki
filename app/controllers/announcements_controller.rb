# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  def index
    @announcements = Announcement.order(created_at: :desc)
  end

  def create
    if current_user.mc
      announcement = Announcement.new announcement_params

      if announcement.save
        redirect_to duties_path, notice: 'New announcement created'
      else
        redirect_to duties_path, alert: 'Failed to create announcement'
      end

    else
      redirect_to duties_path, alert: 'Only MC can manage announcement'
    end
  end

  def update
    if current_user.mc
      announcement = Announcement.find params[:id]

      if announcement.update(announcement_params)
        redirect_to duties_path, notice: 'Announcement updated'
      else
        redirect_to duties_path, alert: 'Failed to update announcement'
      end

    else
      redirect_to duties_path, alert: 'Only MC can manage announcement'
    end
  end

  def destroy
    if current_user.mc
      announcement = Announcement.find params[:id]

      if announcement.destroy
        redirect_to duties_path, notice: 'Announcement removed'
      else
        redirect_to duties_path, alert: 'Failed to remove announcement'
      end

    else
      redirect_to duties_path, alert: 'Only MC can manage announcement'
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:subject, :details)
  end
end
