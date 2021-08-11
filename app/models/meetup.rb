class Meetup < ApplicationRecord
  # enum
  enum status: %w[pending accepted rejected attended closed]

  # belongs_to
  belongs_to :sender, foreign_key: :source_couple_id, class_name: "CoupleProfile"
  # The user being followed
  belongs_to :recipient, foreign_key: :target_couple_id, class_name: "CoupleProfile"

  # has_many
  has_many :meetup_feedbacks, dependent: :destroy

  # validations
  # validate :check_partner_connected

  # callbacks
  after_initialize :set_defaults
  before_save :unread_meetup, if: :will_save_change_to_status?
  before_save :update_is_deleted, if: :will_save_change_to_status?

  # scope
  scope :by_couples, -> (couple_1, couple_2) { where(sender: couple_1, recipient: couple_2).or(Meetup.where(sender: couple_2, recipient: couple_1)) }

  # public methods
  def other_couple(current_couple)
    if current_couple == sender
      recipient
    elsif current_couple == recipient
      sender
    end
  end

  def is_sender(current_couple)
    current_couple == sender
  end

  def is_receiver(current_couple)
    current_couple == recipient
  end

  def chat
    sender.chats.find_by_id(recipient.chats.select(:id))
  end

  def previous_pending_meetups
    Meetup.where("((source_couple_id= ? and target_couple_id= ?) or (source_couple_id= ? and target_couple_id= ?)) and status= ? and id <> ?", source_couple_id, target_couple_id, target_couple_id, source_couple_id, Meetup.statuses['pending'], id)
  end

  private
  def check_partner_connected
    errors.add(:base, "User's partner is not connected.") if sender.secondary_user.blank?
  end

  def set_defaults
    self.status ||= "pending"
  end

  def unread_meetup
    self.is_mark_read = false
  end

  def update_is_deleted
    chat.couple_chats.update(is_deleted: false) if chat
  end
end
