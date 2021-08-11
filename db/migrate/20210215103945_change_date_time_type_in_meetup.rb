class ChangeDateTimeTypeInMeetup < ActiveRecord::Migration[5.2]
  def up
    change_column :meetups, :date_time, :string
  end
end
