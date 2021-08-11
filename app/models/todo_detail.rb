class TodoDetail < ApplicationRecord
  enum name: {complete_your_profile: "complete_your_profile", link_social_media_accounts: "link_social_media_accounts", add_availability: "add_availability", add_photos: "add_photos", reminder_to_respond_to_meeting_invite: "reminder_to_respond_to_meeting_invite", respond_to_any_and_all_new_interactions: "respond_to_any_and_all_new_interactions", invite_partner: "invite_partner", meetup_feedback: "meetup_feedback",upcoming_meetup: "upcoming_meetup",do_for_fun: "do_for_fun",goals: "goals",values_needed: "values_needed"}
  has_one_attached :image

  validates :name, :title, :description, presence: true
  validates_uniqueness_of :name
end
