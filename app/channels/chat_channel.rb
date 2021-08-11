class ChatChannel < ApplicationCable::Channel
  def subscribed
    @chat = current_user.couple_profile.chats.find(params[:chat_id])
    stream_from channel_name(@chat, current_user.couple_profile)
  end

  def speak(data)
    message = @chat.messages.create!(body: data['body'], couple_profile: current_user.couple_profile)
    reciever_couple_profile = @chat.couple_profiles.where.not(id: current_user.couple_profile).first
    data[:message_id] = message.id
    sender_channel_name = channel_name(@chat, current_user.couple_profile)
    reciever_channel_name = channel_name(@chat, reciever_couple_profile)
    message_hash = ChatAndMeetupSerializerService.chat_serializer(message)

    ActionCable.server.broadcast(sender_channel_name, message_hash)
    ActionCable.server.broadcast(reciever_channel_name, message_hash)
    ActionCable.server.broadcast("chat_list-#{reciever_couple_profile.id}", message_hash)
    unless current_user.couple_profile.initial_response_status
      AddEarnCoinsService.call(:initial_response, current_user.couple_profile)
      current_user.couple_profile.update(initial_response_status: true)
    end
    new_chat_notification(reciever_couple_profile,data['body'])
  end

  private

  def channel_name(chat, couple_profile)
    "chat-#{chat.id}-#{couple_profile.id}"
  end

  def tigger_chat_notification(reciever_couple_profile,data_hash,title,notification_message)
    PushNotification.trigger_notification(reciever_couple_profile.primary_user, data_hash, title, notification_message)
    PushNotification.trigger_notification(reciever_couple_profile.secondary_user, data_hash, title, notification_message) if reciever_couple_profile.secondary_user
  end

  def new_chat_notification(reciever_couple_profile,message_body)
    title = current_user.couple_profile.name
    notification_message = message_body
    data_hash = {notificationable_id: current_user.couple_profile.id , notificationable_type: 'new_chat_message'}
    tigger_chat_notification(reciever_couple_profile,data_hash,title,notification_message)
  end
end
