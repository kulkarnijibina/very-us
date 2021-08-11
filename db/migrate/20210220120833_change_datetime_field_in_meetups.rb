class ChangeDatetimeFieldInMeetups < ActiveRecord::Migration[5.2]
  def change
    remove_column :meetups, :date_time, :string
    add_column :meetups, :date_time, :datetime

    Meetup.reset_column_information
    Meetup.destroy_all
  end
end
