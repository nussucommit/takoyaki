class AddReceiveEmailToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :receive_email, :boolean, default: true, null: false 
  end
end
