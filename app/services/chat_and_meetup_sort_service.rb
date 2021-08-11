module ChatAndMeetupSortService
  class << self

    def call(chat, couple_profile, receiver_couple_profile)
    	clear_chat = chat.couple_chats.where(couple_profile_id: couple_profile).first.clear_chat
    	if clear_chat.present?
      	chat_history =  chat.messages.where("created_at > ?", clear_chat).order('created_at DESC').to_a
      else
      	chat_history =  chat.messages.order('created_at DESC').to_a
      end
      meetups = chat.meetups.order('created_at DESC').to_a
      chat_history = chat_history + meetups
      chat_history_and_meet_ups = chat_history.sort_by{ |chat| chat[:created_at] }.reverse
      ChatAndMeetupSerializerService.call(chat_history_and_meet_ups)
    end

  end
end