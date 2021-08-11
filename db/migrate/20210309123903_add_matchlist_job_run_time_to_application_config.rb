class AddMatchlistJobRunTimeToApplicationConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :application_configs, :matchlist_job_run_time, :datetime


    reversible do |dir|
      dir.up do
        ApplicationConfig.reset_column_information
        ApplicationConfig.configuration.update(matchlist_job_run_time: (Time.current + ApplicationConfig.configuration.matchlist_scheduler_time_in_hours.hours))
      end
    end
  end
end
