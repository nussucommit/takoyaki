class AddFreeToDuties < ActiveRecord::Migration[5.1]
  def change
    add_column :duties, :free, :boolean
  end
end
