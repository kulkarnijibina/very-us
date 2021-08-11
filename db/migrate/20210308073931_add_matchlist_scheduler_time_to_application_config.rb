class AddMatchlistSchedulerTimeToApplicationConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :application_configs, :matchlist_scheduler_time_in_hours, :integer
    add_column :application_configs, :reward_karma_score_time_in_hours, :integer
    add_column :application_configs, :save_for_later_scheduler_time_in_hours, :integer
    add_column :application_configs, :refresh_free_save_for_later_time_in_hours, :integer
  end
end
