class CreateDuties < ActiveRecord::Migration[5.1]
  def change
    create_table :duties do |t|
      t.references :user, foreign_key: true
      t.references :timeslot, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
