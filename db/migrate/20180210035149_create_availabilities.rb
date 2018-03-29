class CreateAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :availabilities do |t|
      t.references :user, foreign_key: true
      t.integer :day
      t.references :time_range, foreign_key: true

      t.timestamps
    end
  end
end
