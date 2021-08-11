# ChatAndMeetupSerializerService.chat_serializer(message)
# ChatAndMeetupSerializerService.meetup_serializer(meetup)

module ChatAndMeetupSerializerService
  class << self

    def call(chats)
      chats_and_meetups = []
      chats.each do |chat|
        if chat.class.name == "Message"
          chats_and_meetups.push(chat_serializer(chat))
        else
          chats_and_meetups.push(meetup_serializer(chat))
        end
      end
      chats_and_meetups
    end

    def chat_serializer(chat)
      {
        "type": "message",
        "message_id": chat.id,
        "body": chat.body,
        "read_status": chat.is_mark_read,
        "chat_id": chat.chat_id,
        "date": chat.message_date,
        "couple_profile_id": chat.couple_profile_id
      }
    end

    def meetup_serializer(meet_up)
      {
        "type": "meetup",
        "meetup_id": meet_up.id,
        "status": meet_up.status,
        "date_time": meet_up.date_time,
        "location": meet_up.location,
        "description": meet_up.description,
        "source_couple_id": meet_up.source_couple_id,
        "target_couple_id": meet_up.target_couple_id,
        "chat_id": meet_up.chat&.id,
      }
    end

    def chat_users(source_couple, target_couple)
      {
        "current_couple": ActiveModelSerializers::SerializableResource.new(source_couple, serializer: Api::V1::ChatCoupleProifileSerializer),
        "target_couple": ActiveModelSerializers::SerializableResource.new(target_couple, serializer: Api::V1::ChatCoupleProifileSerializer)
      }
    end

  end
end