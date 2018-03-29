class AddAttributeIsBlockedToProblemReport < ActiveRecord::Migration[5.1]
  def change
    add_column :problem_reports, :is_blocked, :boolean
  end
end
