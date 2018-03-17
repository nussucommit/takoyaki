class AddAttributesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    add_column :users, :matric_num, :string
    add_column :users, :contact_num, :string
  end
end
