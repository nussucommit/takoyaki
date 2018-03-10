class AddNotNullConstraintInAnnouncements < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :announcements, :subject, false
  	change_column_null :announcements, :details, false
  end
end
