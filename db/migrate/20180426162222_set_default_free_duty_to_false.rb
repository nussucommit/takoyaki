class SetDefaultFreeDutyToFalse < ActiveRecord::Migration[5.1]
  def change
    change_column_null :duties, :free, false, false
    change_column :duties, :free, :boolean, default: false
  end
end
