class AddUserTimeslotDateUniqueTupleOnDuty < ActiveRecord::Migration[5.1]
  def change
    add_index :duties, %i[user_id timeslot_id date], unique: true
  end
end
