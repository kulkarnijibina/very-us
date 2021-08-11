class Image < ApplicationRecord
  belongs_to :couple_profile
  has_one_attached :image

  validate :image_attached

  # callbacks
  after_save :make_other_images_profile_pic_false, if: :is_profile_pic

  def other_images
    couple_profile.images.where.not(id: self)
  end

  private
  def make_other_images_profile_pic_false
    other_images.update(is_profile_pic: false)
  end

  def image_attached
    errors.add(:image, "not attached.") if !image.attached?
  end
end
