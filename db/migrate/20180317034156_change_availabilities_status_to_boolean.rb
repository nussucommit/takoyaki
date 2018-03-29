class ChangeAvailabilitiesStatusToBoolean < ActiveRecord::Migration[5.1]
  def change
    remove_column :availabilities, :status
    add_column :availabilities, :status, :boolean
  end
end
