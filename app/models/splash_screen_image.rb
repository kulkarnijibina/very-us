class SplashScreenImage < ApplicationRecord
  require "mini_magick"
  belongs_to :imageable, polymorphic: true
  has_one_attached :image
  before_save :add_height_and_width

  def is_attached
    unless self.image.attached?
      errors.add(:image, "not attached.")
    end
  end

  def add_height_and_width
    image_meta = ActiveStorage::Analyzer::ImageAnalyzer.new(self.image).metadata
    self.height = image_meta[:height]
    self.width = image_meta[:width]
  end

end
