class MeetupFeedback < ApplicationRecord
  belongs_to :meetup
  belongs_to :source_couple, class_name: "CoupleProfile", foreign_key: "source_couple_id"
  belongs_to :target_couple, class_name: "CoupleProfile",foreign_key: "target_couple_id"

  after_save :verified_couple_profile

  def verified_couple_profile
    if target_couple.verified_profile == false && target_couple.received_meetup_feedbacks.count > 3
      AddEarnCoinsService.call(:verification_status, target_couple)
      target_couple.update(verified_profile: true)
    end
  end
end
