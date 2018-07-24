class EnsureUniqueDuty < ActiveRecord::Migration[5.1]
  def change
    remove_index :duties, column: %i[user_id timeslot_id date]
    add_index :duties, %i[date timeslot_id], unique: true
  end
end
