class ChangeDayType < ActiveRecord::Migration[5.1]
  def change
    change_column :timeslots, :day, :text
  end
end
