class ChangePlaceAttributeFromStringToReferenceInProblemReport < ActiveRecord::Migration[5.1]
  def change
    remove_column :problem_reports, :venue
    add_column :problem_reports, :place_id, :integer
    add_foreign_key :problem_reports, :places
  end
end
