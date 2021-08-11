class Message < ApplicationRecord
  belongs_to :couple_profile
  belongs_to :chat
  enum message_type: { text: 0,  file: 1 }
  validates :body, presence: true
  validate :check_blocked_couple
  # validate :check_partner_connected
  validate :check_chat_availability
  validate :check_couple_active
  after_create :update_is_deleted

  def message_date
    created_at
  end

  def check_blocked_couple
  	other_couple_profile = chat.couple_profiles.where.not(id: couple_profile_id).first
    blocked_couple = Relationship.is_blocked(couple_profile_id, other_couple_profile)
    errors.add(:chat, "is blocked.") if blocked_couple.present?
  end

  def check_partner_connected
  	errors.add(:chat, "User's partner is not connected.") if couple_profile.secondary_user.blank?
  end

  def check_chat_availability
  	errors.add(:chat, "Chat message is not available.") unless couple_profile.chat_availability
  end

  def check_couple_active
    errors.add(:chat, "The couple you are trying to chat is deactivated their account.") unless chat.other_couple(couple_profile)&.active?
  end

  def update_is_deleted
    chat.reload.couple_chats.update(is_deleted: false)
  end
end
