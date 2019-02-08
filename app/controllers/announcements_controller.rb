# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  def index
    @announcements = Announcement.order(created_at: :desc)
  end

  def create
    if current_user.mc
      announcement = Announcement.new announcement_params

      redirect_to duties_path if announcement.save
    else
      redirect_to duties_path
    end
  end

  def update
    if current_user.mc
      announcement = Announcement.find params[:id]

      redirect_to duties_path if announcement.update announcement_params
    else
      redirect_to duties_path
    end
  end

  def destroy
    if current_user.mc
      announcement = Announcement.find params[:id]

      redirect_to duties_path if announcement.destroy
    else
      redirect_to duties_path
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:subject, :details)
  end

class PostsController < ApplicationController
  before_filter :check_quota 
	
  def check_quota
	if user.posts.count >=3
		@quota_warning = "You've reached maximum posts you can import"
		end
	end
  end
end
