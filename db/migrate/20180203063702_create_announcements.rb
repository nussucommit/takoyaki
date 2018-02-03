class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      t.timestamp :date
      t.references :user, foreign_key: true
      t.text :subject
      t.text :details

      t.timestamps
    end
  end
end
