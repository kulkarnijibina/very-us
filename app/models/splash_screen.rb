class SplashScreen < ApplicationRecord
  require "mini_magick"
  has_many :splash_screen_images, as: :imageable, dependent: :destroy
  validates :title, :text1, :background_color, :priority, presence: true
  validates :title, length: {maximum: 22}
  validates :text1, length: {maximum: 32}
  validates :text2, length: {maximum: 32}
  validates :text3, length: {maximum: 32}
  validates :splash_screen_images, length: {minimum: 3, :message=>"At least 3 images should be uploaded."}
  validate :check_height_and_width
  # callbacks
  after_initialize :set_defaults

  accepts_nested_attributes_for :splash_screen_images

  def check_height_and_width
    return unless splash_screen_images.present?
    image_meta1 = ActiveStorage::Analyzer::ImageAnalyzer.new(splash_screen_images.first.image).metadata
    splash_screen_images.each_with_index do |splash_screen_image, index|
      image_meta2 = ActiveStorage::Analyzer::ImageAnalyzer.new(splash_screen_image.image).metadata
      unless image_meta1[:width]*(index+1) == image_meta2[:width] && image_meta1[:height]*(index+1) == image_meta2[:height]
        errors.add(:splash_screen_images, "Image #{index+1} dimensions should be #{index+1} times of first image")
      end
    end
  end

  private
  def set_defaults
    self.priority||= 1
  end

end
