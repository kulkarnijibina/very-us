class BurnOn < ApplicationRecord
  include Configuration

  BROWSE  = [:refresh_match_list, :refresh_matches_count, :per_save_for_later, :per_save_for_later_duration_in_days, :daily_free_per_save_for_later, :change_preference,
            :change_geography, :edit_tags_on_match_list, :spotlight_focus,
            :spotlight_duration_in_mins, :incognito_mode,
            :incognito_duration_in_mins, :near_by_location_in_km].freeze

  ALL_OPTIONS = {
    'Browse' => BROWSE
  }.freeze

  DEFAULTS = {
    refresh_match_list: 1.5,
    refresh_matches_count: 5,
    per_save_for_later: 1,
    per_save_for_later_duration_in_days: 7,
    daily_free_per_save_for_later: 1,
    change_preference: 1,
    change_geography: 1,
    incognito_mode: 2,
    incognito_duration_in_mins: 30,
    spotlight_focus: 1,
    spotlight_duration_in_mins: 30,
    edit_tags_on_match_list: 1,
    near_by_location_in_km: 30
  }.freeze

  after_initialize :set_defaults

  class << self
    def configuration
      active.first
    end

    def get_label(field)
      I18n.t("models.burn_on.label.#{field}")
    end

    def incognito_duration
      configuration.incognito_duration_in_mins.minutes.ago.in_time_zone
    end

    def spotlight_duration
      configuration.spotlight_duration_in_mins.minutes.ago.in_time_zone
    end

    def per_save_for_later_duration
      configuration.per_save_for_later_duration_in_days.days
    end
  end

  private
  def set_defaults
    DEFAULTS.each do |k,v|
      self.send("#{k}=", send(k) || v)
    end
  end
end
