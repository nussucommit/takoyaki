# frozen_string_literal: true

module AnnouncementsHelper
  DetailsLength = 90

	def format_time(time)
    time.localtime.strftime("%d %B %C%y, %I:%M %p")
  end
end
