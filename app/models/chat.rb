class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :couple_chats, dependent: :destroy
  has_many :couple_profiles, through: :couple_chats
  enum is_deleted: { disabled: true, live: false }

  after_create :create_name

  def other_couple(couple_profile)
    couple_profiles.where.not(id: couple_profile).first
  end

  def meetups
    Meetup.by_couples(couple_profiles.first, couple_profiles.second)
  end

  private
  def create_name
    update(name: "channel_name_#{id}")
  end
end
