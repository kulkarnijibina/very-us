module UpdateCrontabService
  CAP_ENV_NAMES = {
    "staging" => "very_us_staging",
    "production" => "very_us_production",
  }.freeze

  class << self
    def call
      env_name = CAP_ENV_NAMES[Rails.env].to_s
      update_command = "RAILS_ENV=#{Rails.env} bundle exec whenever --update-crontab #{env_name} --set 'environment=#{Rails.env}'"
      system(update_command)
    end
  end
end
