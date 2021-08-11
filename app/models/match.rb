class Match < ApplicationRecord
  belongs_to :bucket
  belongs_to :source_couple, class_name: "CoupleProfile", foreign_key: "source_couple_id"
  belongs_to :target_couple, class_name: "CoupleProfile",foreign_key: "target_couple_id"

  scope :spotlight_on, -> { joins(:target_couple).where('couple_profiles.spotlight_on_time is not null and couple_profiles.spotlight_on_time > ?',BurnOn.spotlight_duration) }
  scope :not_incognito, -> { joins(:target_couple).where.not('couple_profiles.incognito_time is not null and couple_profiles.incognito_time > ?',BurnOn.incognito_duration) }
  scope :activated_couples, -> { joins(:target_couple).where('couple_profiles.status = ?',CoupleProfile.statuses[:active]) }

  validates :source_couple, uniqueness: { scope: [:target_couple] }
end
