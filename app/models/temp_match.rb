class TempMatch < ApplicationRecord
	belongs_to :source_couple, class_name: "CoupleProfile", foreign_key: "source_couple_id"
	belongs_to :target_couple, class_name: "CoupleProfile",foreign_key: "target_couple_id"
end
