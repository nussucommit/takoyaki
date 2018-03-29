class AddCellToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :cell, :integer
  end
end
