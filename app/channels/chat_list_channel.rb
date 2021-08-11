class ChatListChannel < ApplicationCable::Channel
  def subscribed
    stream_from channel_name(current_user.couple_profile)
  end

  private

  def channel_name(couple_profile)
    "chat_list-#{couple_profile.id}"
  end
end
