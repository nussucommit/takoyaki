class ChangeDescriptionAndRemarksTypeFromProblemReport < ActiveRecord::Migration[5.1]
  def change
    change_column :problem_reports, :description, :text
    change_column :problem_reports, :remarks, :text
  end
end
