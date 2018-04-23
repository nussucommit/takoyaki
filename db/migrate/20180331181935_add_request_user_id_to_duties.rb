class AddRequestUserIdToDuties < ActiveRecord::Migration[5.1]
  def change
    add_column :duties, :request_user_id, :integer
  end
end
