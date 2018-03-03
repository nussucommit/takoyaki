class RemoveDateColumnFromAnnouncements < ActiveRecord::Migration[5.1]
  def change
  	remove_column :announcements, :date
  end
end
