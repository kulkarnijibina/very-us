class Location < ApplicationRecord
	belongs_to :locationable, polymorphic: true
	validates :latitude, :longitude, presence: true

  # callbacks
  after_initialize :set_defaults

  private
  def set_defaults
    self.latitude = latitude.presence || LocationConfig.configuration.default_latitude
    self.longitude = longitude.presence || LocationConfig.configuration.default_longitude
  end
end
