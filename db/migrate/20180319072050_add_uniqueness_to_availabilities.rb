class AddUniquenessToAvailabilities < ActiveRecord::Migration[5.1]
  def change
    add_index :availabilities, [:user_id, :time_range_id, :day], unique: true
  end
end
