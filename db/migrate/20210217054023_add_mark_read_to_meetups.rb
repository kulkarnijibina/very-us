class AddMarkReadToMeetups < ActiveRecord::Migration[5.2]
  def change
    add_column :meetups, :is_mark_read, :boolean, default: false
  end
end
