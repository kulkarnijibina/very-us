env :PATH, ENV['PATH']
require_relative './environment'

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "log/cron_log.log"
# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#

def reward_karma_score_time
  ApplicationConfig.configuration.reward_karma_score_time_in_hours
end

def save_for_later_scheduler_time
  ApplicationConfig.configuration.save_for_later_scheduler_time_in_hours
end

def matchlist_scheduler_time
  ApplicationConfig.configuration.matchlist_scheduler_time_in_hours
end

def refresh_free_save_for_later_time
  ApplicationConfig.configuration.refresh_free_save_for_later_time_in_hours
end

every matchlist_scheduler_time.hours do
  rake "matches_reset:create"
end

every refresh_free_save_for_later_time.hours do
  rake "refresh_free_save_for_later:update"
end

every reward_karma_score_time.hours do
  rake "reward_karma_score:create"
end

every save_for_later_scheduler_time.days do
  rake "send_notification_for_save_for_later:update"
end

# Learn more: http://github.com/javan/whenever
