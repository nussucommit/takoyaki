class RemoveUserColumnFromAnnouncement < ActiveRecord::Migration[5.1]
  def change
  	remove_column :announcements, :user_id
  end
end
