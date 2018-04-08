class AddDefaultAttributeValueToModel < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:problem_reports, :is_fixed, false)
    change_column_default(:problem_reports, :is_fixable, true)
    change_column_default(:problem_reports, :is_blocked, false)
  end
end
