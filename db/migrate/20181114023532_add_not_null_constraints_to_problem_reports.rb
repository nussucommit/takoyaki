# frozen_string_literal: true

class AddNotNullConstraintsToProblemReports < ActiveRecord::Migration[5.2]
  def change
    change_column :problem_reports, :is_fixed, :boolean, null: false
    change_column :problem_reports, :is_fixable, :boolean, null: false
    change_column :problem_reports, :is_blocked, :boolean, null: false
    change_column :problem_reports, :computer_number, :string, null: false
    change_column :problem_reports, :description, :text, null: false
  end
end
