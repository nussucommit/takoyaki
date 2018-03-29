class AddStatusToAvailabilities < ActiveRecord::Migration[5.1]
  def change
    add_column :availabilities, :status, :integer
  end
end
