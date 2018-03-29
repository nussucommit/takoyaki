class AddNotNullToAvailabilitiesStatus < ActiveRecord::Migration[5.1]
  def change
    change_column :availabilities, :status, :boolean, null: false
  end
end
