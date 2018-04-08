class AddAttributesToProblemReport < ActiveRecord::Migration[5.1]
  def change
    add_column :problem_reports, :venue, :string
    add_column :problem_reports, :computer_number, :string
    add_column :problem_reports, :description, :string
    add_column :problem_reports, :is_critical, :boolean
    add_column :problem_reports, :is_fixed, :boolean
    add_column :problem_reports, :is_fixable, :boolean
    add_column :problem_reports, :remarks, :string
  end
end
