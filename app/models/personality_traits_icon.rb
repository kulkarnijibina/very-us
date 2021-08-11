class PersonalityTraitsIcon < ApplicationRecord
  has_one_attached :unselected_icon
  validates :unselected_icon, :selected_icon, :name, presence: true
  has_one_attached :selected_icon

  validate :is_attached

  def is_attached

  	errors.add(:unselected_icon, "not attached.") if !unselected_icon.attached?

  	errors.add(:selected_icon, "not attached.") if !selected_icon.attached?

  end

end
