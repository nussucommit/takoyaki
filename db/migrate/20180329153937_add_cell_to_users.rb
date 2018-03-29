class AddCellToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :cell, :string
  end
end
