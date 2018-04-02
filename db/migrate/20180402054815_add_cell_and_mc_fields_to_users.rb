class AddCellAndMcFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :cell, :integer, null: false
    add_column :users, :mc, :boolean, default: false, null: false
  end
end
