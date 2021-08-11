class Bucket < ApplicationRecord
  KEYS = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"].freeze

  DEFAULTS = {
    monday: 0,
    tuesday: 0,
    wednesday: 0,
    thursday: 0,
    friday: 0,
    saturday: 0,
    sunday: 0,
  }.freeze

  has_many :matches, dependent: :destroy

  # callbacks
  after_initialize :set_defaults

  private
  def set_defaults
    self.threshold_percentage ||= 20
    self.percentage_for_day ||= DEFAULTS
  end
end
