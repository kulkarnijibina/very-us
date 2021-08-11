class LocationConfig < ApplicationRecord
  include Configuration

  validates :default_latitude, :default_longitude, presence: true

  # callbacks
  after_initialize :set_defaults

  # to get location config
  def self.configuration
    all.active.first
  end

  private
  def set_defaults
    self.default_latitude ||= '1.355545'
    self.default_longitude ||= '103.867656'
  end
end
