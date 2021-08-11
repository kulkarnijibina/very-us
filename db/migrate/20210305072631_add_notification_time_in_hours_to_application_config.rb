class AddNotificationTimeInHoursToApplicationConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :application_configs, :complete_profile_notify_time_in_hours, :integer
    add_column :application_configs, :add_partner_notify_time_in_hours, :integer
    add_column :application_configs, :fill_feedback_notify_time1_in_hours, :integer
    add_column :application_configs, :fill_feedback_notify_time2_in_hours, :integer
  end
end
