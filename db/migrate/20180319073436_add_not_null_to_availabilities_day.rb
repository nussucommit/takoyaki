class AddNotNullToAvailabilitiesDay < ActiveRecord::Migration[5.1]
  def change
    change_column :availabilities, :day, :integer, null: false
  end
end
