class CreateProblemReports < ActiveRecord::Migration[5.1]
  def change
    create_table :problem_reports do |t|
      t.references :reporter_user
      t.references :last_update_user

      t.timestamps
    end
  end
end
