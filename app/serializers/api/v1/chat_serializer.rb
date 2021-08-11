class Api::V1::ChatSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_message, :message_date, :unread_count, :chat_with_couple, :blocked_by

  @hash = {}

  def blocked_by
    other_couple_profile = object.couple_profiles.where.not(id: instance_options[:couple_profile_id]).first
    Relationship.is_blocked(instance_options[:couple_profile_id], other_couple_profile)
  end

  def last_message
    msg = last_msg
    if msg.is_a?(Meetup)
      ChatAndMeetupSerializerService.meetup_serializer(msg)
    elsif msg.is_a?(Message)
      ChatAndMeetupSerializerService.chat_serializer(msg)
    else
      {message_id: nil, body: "", couple_profile_id: nil, chat_id: object.id}
    end
  end

  def message_date
    last_msg&.created_at || object.created_at
  end

  def chat_with_couple
    other_couple_profile = object.couple_profiles.where.not(id: instance_options[:couple_profile_id]).first
    if other_couple_profile
      profile_pic = other_couple_profile.profile_pic.present? ? Api::V1::ImageSerializer.new(other_couple_profile.profile_pic) : nil
      {id: other_couple_profile.id, name: other_couple_profile.name, profile_pic: profile_pic}
    else
      {}
    end
  end

  def unread_count
    unread_messages.count + unread_meetups
  end

  def unread_messages
    messages_in_desc_order.where.not(couple_profile_id: instance_options[:couple_profile_id],  is_mark_read: true)
  end

  def unread_meetups
    receiver_unread_meetup = object.meetups.where(target_couple_id: instance_options[:couple_profile_id]).pending.where(is_mark_read: false).count
    sender_unread_meetup = object.meetups.where(source_couple_id: instance_options[:couple_profile_id]).accepted.where(is_mark_read: false).count
    receiver_unread_meetup + sender_unread_meetup
  end

  def last_chat
  end

  def last_msg
    last_message = messages_in_desc_order.first
    last_meetup = meetups_in_desc_order.first
    (last_message.present? && last_meetup.present?) ? ((last_message.created_at > last_meetup.created_at) ? last_message : last_meetup) : last_message.present? ? last_message : last_meetup
  end

  def messages_in_desc_order
    clear_chat = object.couple_chats.where(couple_profile_id: instance_options[:couple_profile_id]).first&.clear_chat
    if clear_chat.present?
      object.messages.where("created_at > ?", clear_chat).order('messages.created_at DESC')
    else
      object.messages.order('messages.created_at DESC')
    end
  end

  def meetups_in_desc_order
    object.meetups.order('created_at DESC')
  end
end
