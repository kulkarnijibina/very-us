class Api::V1::ChatsController < ApiController
  before_action :authenticate_user!
  before_action :find_chat, only: [:read_messages,:clear_chats,:delete_chat]
  before_action :validate_current_user_chat, only: [:read_messages,:clear_chats]
  before_action :check_current_user, only:[:create]



  def create
    chat= current_user.couple_profile.chats.where(id: User.find(params['receiver_id']).couple_profile.chats.pluck(:id)).first
    if  chat
      chat
    else
      chat = Chat.create
      second_user = User.find(params['receiver_id'])
      chat.couple_profiles << second_user.couple_profile
      chat.couple_profiles << current_user.couple_profile
    end
    render json: {chat_room: chat}
  end

  def chat_list
    deleted_chat_ids = current_user.couple_profile.couple_chats.where(is_deleted: true).pluck(:chat_id)
    chat_ids = current_user.couple_profile.chats.joins(:messages)
      .where("(messages.created_at > ? AND messages.couple_profile_id <> ?) OR (chats.created_at > ?)", chat_inactivity_threshold, current_user.couple_profile.id, chat_inactivity_threshold)
      .distinct.ids
    source_couple_ids = current_user.couple_profile.received_meetups.where('created_at > ?', chat_inactivity_threshold).select(:source_couple_id).distinct
    meetup_chat_ids = Chat.joins(:couple_chats).where(couple_chats: {couple_profile: source_couple_ids}).ids
    chat_ids = chat_ids + meetup_chat_ids - deleted_chat_ids
    chats = current_user.couple_profile.chats.where(id: chat_ids).includes(:messages).order('messages.created_at DESC').distinct
     render json: {
      message: 'success',
      data: {
        "chats".to_sym => ActiveModel::Serializer::CollectionSerializer.new(chats, serializer: Api::V1::ChatSerializer, couple_profile_id: current_user.couple_profile.id)
    }}, status: :ok
  end

  # not used
  def chat_list_unread
    chats = current_user&.couple_profile.chats.includes(:messages).where.not(messages:{couple_profile_id:current_user.couple_profile.id,is_mark_read:true}).order('messages.created_at DESC')&.uniq
    render json: {message: 'success',
      data: {"chats".to_sym => ActiveModel::Serializer::CollectionSerializer.new(chats, serializer: Api::V1::ChatSerializer, unread: 0, couple_profile_id: current_user.couple_profile.id)
    }}, status: :ok
  end

  def check_unread_chats
    unread_chats = current_user.couple_profile.unread_chats.exists?
    render_success_response({unread_chats: unread_chats})
  end

  def history
    receiver_couple_profile = get_couple_profile(params[:couple_profile_id], params[:receiver_id])
    chat = current_user.couple_profile.chats.where(id: receiver_couple_profile.chats.pluck(:id)).first
    is_reported = current_user.couple_profile.relationships.is_reported.where(target_couple: receiver_couple_profile).exists?
    if chat
      chat_history =  chat.messages.order('created_at DESC')
      chat_history_and_meet_ups = ChatAndMeetupSortService.call(chat, current_user.couple_profile, receiver_couple_profile)
      render_success_response({
        chat_id: chat.id,
        blocked_by: Relationship.is_blocked(current_user.couple_profile, receiver_couple_profile),
        messages: chat_history_and_meet_ups,
        chat_users: ChatAndMeetupSerializerService.chat_users(current_user.couple_profile, receiver_couple_profile),
        is_reported: is_reported,
        is_disabled: !receiver_couple_profile.active?,
      }, 'success')
    else
      render_unprocessable_entity("Chat not found with this couple")
    end
  end

  def read_messages
    @chat.messages.where.not(couple_profile_id: current_user.couple_profile.id).update(is_mark_read: true)
    current_user.couple_profile.received_meetups.pending.update(is_mark_read: true)
    current_user.couple_profile.sent_meetups.accepted.update(is_mark_read: true)
    render_message "messages read successfully"
  end

  def clear_chats
    @chat.couple_chats.where(couple_profile: current_user.couple_profile).update(clear_chat: Time.current)
    render_message "Chat Cleared Successfully"
  end

  def delete_chat
   chats = @chat.couple_chats.where(couple_profile: current_user.couple_profile).update(clear_chat: Time.current, is_deleted: true)
    render_success_response({deleted_chats: chats})
  end

  private

  def check_current_user
    render_unprocessable_entity "you are not allowed to create a chat for own" if current_user.couple_profile.id == params['receiver_id'].to_i
  end

  def check_chat_live
    @chat =  current_user.couple_profile.chats&.where(is_deleted: "live")
    render_unprocessable_entity "this chat is no longer exists" and return if @chat.blank?
  end

  def find_chat
    @chat = Chat.find_by_id(params[:chat_id])
    render_unprocessable_entity "chat room is not valid or no longer exists" unless @chat
  end

  def validate_current_user_chat
    render_unprocessable_entity "current user not belong to this chat" unless @chat.couple_profiles.find_by_id(current_user.couple_profile.id)
  end

  def get_couple_profile(couple_profile_id, receiver_id)
    if couple_profile_id
      CoupleProfile.find(couple_profile_id)
    else
      User.find(receiver_id).couple_profile
    end
  end

  def chat_inactivity_threshold
    ApplicationConfig.configuration.chat_inactivity_threshold_in_days.days.ago
  end
end
