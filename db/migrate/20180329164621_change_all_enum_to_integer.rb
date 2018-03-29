class ChangeAllEnumToInteger < ActiveRecord::Migration[5.1]
  def change
    remove_column :availabilities, :day
    add_column :availabilities, :day, :integer
    remove_column :timeslots, :day
    add_column :timeslots, :day, :integer
  end
end
