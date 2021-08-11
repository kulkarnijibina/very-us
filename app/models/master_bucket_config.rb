# MasterBucketConfig.configuration
class MasterBucketConfig < ApplicationRecord
  include Configuration

  KEYS = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"].freeze

  DEFAULTS = {
    monday: 5,
    tuesday: 5,
    wednesday: 5,
    thursday: 5,
    friday: 5,
    saturday: 5,
    sunday: 5,
  }.freeze

  # callbacks
  after_initialize :set_defaults

  # to get master bucket config
  def self.configuration
    active.first
  end

  private
  def set_defaults
    self.match_count_for_day ||= DEFAULTS
  end
end
