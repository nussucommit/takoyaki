class AddForeignKeyFromProblemReportToUser < ActiveRecord::Migration[5.1]
  def change
    remove_reference :problem_reports, :reporter_user
    remove_reference :problem_reports, :last_update_user
    add_column :problem_reports, :reporter_user_id, :integer
    add_column :problem_reports, :last_update_user_id, :integer
    add_foreign_key :problem_reports, :users, column: :reporter_user_id,
       primary_key: :id
    add_foreign_key :problem_reports, :users, column: :last_update_user_id,
     primary_key: :id
  end
end
