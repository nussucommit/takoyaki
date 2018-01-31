class CreateTimeslots < ActiveRecord::Migration[5.1]
  def change
    create_table :timeslots do |t|
      t.boolean :mc_only
      t.date :day
      t.references :user, foreign_key: true
      t.references :time_range, foreign_key: true
      t.references :place, foreign_key: true

      t.timestamps
    end
  end
end
