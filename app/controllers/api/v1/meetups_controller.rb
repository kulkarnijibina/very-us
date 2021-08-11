class Api::V1::MeetupsController < ApiController
  before_action :set_meetup, only: [:update, :destroy]
  before_action :validate_status, only: [:update]

  def index
    received_meetups = current_user.couple_profile.received_meetups
    render_success_response({
                              meetups: array_serializer.new(received_meetups, serializer: Api::V1::MeetupSerializer)
                            }, 'Received Meetup invites', 200)
  end

  def create
    meetup = current_user.couple_profile.sent_meetups.new(create_meetup_params)
    if meetup.save
      other_meetup = meetup.previous_pending_meetups
      other_meetup.update(status: 'rejected')
      broadcast_meetup_to_chat_channel(meetup)
      render_success_response({ meetup: meetup }, 'Meetup Invite created sucessfully')
    else
      render_unprocessable_entity_response(meetup)
    end
  end

  def update
    award_coins = need_to_award_coins_for_meetup?()
    if @meetup.update(update_meetup_params)
      if @meetup.accepted?
        accepted_meetup_feedback_notification(@meetup)
      end
      add_coins_to_meetup_profiles(@meetup) if award_coins
      broadcast_meetup_to_chat_channel(@meetup)
      render_success_response({meetup: single_serializer.new(@meetup, serializer: Api::V1::UpdateMeetupSerializer)}, 'Meetup updated sucessfully')
    else
      render_unprocessable_entity_response(@meetup)
    end
  end

  def destroy
    render_unprocessable_entity_response(@meetup) and return unless @meetup.destroy
    render_success_response
  end

  def sent_invites
    render_success_response({ meetups: current_user.couple_profile.sent_meetups }, 'Sent meetup invites')
  end

  def give_feedback
    @meetup = current_user.couple_profile.all_meetups.find(params[:id])
    meetup_feedback = @meetup.meetup_feedbacks.build(feedback_params)
    target_couple = @meetup.other_couple(current_user.couple_profile)
    if meetup_feedback.save
      meetup_feedback_notification(target_couple)
      response = AddEarnCoinsService.call(:feedback_fill_per_couple_meet, current_user.couple_profile)
      render_success_response({feedback: meetup_feedback, earned_coins: response[:earned_coins]}, "feedback submitted sucessfully")
    else
      render_unprocessable_entity_response(meetup_feedback)
    end
  end

  private

  def set_meetup
    @meetup = current_user.couple_profile.all_meetups.find(params[:id])
  end

  def create_meetup_params
    params.require(:meetup).permit(:target_couple_id, :description, :date_time, :location)
  end

  def update_meetup_params
    params.require(:meetup).permit(:status)
  end

  def feedback_params
    params.require(:feedback).permit(:is_couple_same,:meet_again,:couple_behaviour,:couple_badge)
      .merge(source_couple: current_user.couple_profile, target_couple: @meetup.other_couple(current_user.couple_profile))
  end

  def validate_status
    desired_status = update_meetup_params[:status]
    available_statuses = get_available_statuses
    render_unprocessable_entity("Can't change status to #{desired_status}, available_statuses: #{available_statuses.to_sentence}") unless available_statuses.include?(desired_status)
  end

  def get_available_statuses
    is_sender = @meetup.is_sender(current_user.couple_profile)
    case @meetup.status
    when "pending"
      is_sender ? ["rejected"] : ["accepted", "rejected"]
    when "accepted"
      ["attended", "rejected"]
    else
      []
    end
  end

  def need_to_award_coins_for_meetup?
    update_meetup_params[:status] == "accepted" && @meetup.pending?
  end

  def add_coins_to_meetup_profiles(meetup)
    AddEarnCoinsService.call(:per_accept_chat, meetup.recipient)
    AddEarnCoinsService.call(:per_accept_chat, meetup.sender)
  end

  def broadcast_meetup_to_chat_channel(meetup, send_to=["sender", "recipient"])
    other_couple_profile = meetup.other_couple(current_user.couple_profile)
    chat = meetup.chat
    meetup_hash = ChatAndMeetupSerializerService.meetup_serializer(meetup)
    if chat
      ActionCable.server.broadcast(channel_name(chat, meetup.sender), meetup_hash) if send_to.include?("sender")
      ActionCable.server.broadcast(channel_name(chat, meetup.recipient), meetup_hash) if send_to.include?("recipient")
      meetup_invite_notification(chat,other_couple_profile)
    end
    ActionCable.server.broadcast("chat_list-#{other_couple_profile.id}", meetup_hash)

  end

  def channel_name(chat, couple_profile)
    "chat-#{chat.id}-#{couple_profile.id}"
  end

  def trigger_meetup_notification(reciever_couple_profile,data_hash,title,notification_message)
    PushNotification.trigger_notification(reciever_couple_profile.primary_user, data_hash, title, notification_message)
    PushNotification.trigger_notification(reciever_couple_profile.secondary_user, data_hash, title, notification_message) if reciever_couple_profile.secondary_user
  end

  def meetup_invite_notification(chat,other_couple_profile)
    title = current_user.couple_profile.name
    notification_message = "Sent you a meetup"
    data_hash = {notificationable_id: current_user.couple_profile.id , notificationable_type: 'meetup_invite'}
    trigger_meetup_notification(other_couple_profile,data_hash,title,notification_message)
  end
  def meetup_feedback_notification(target_couple)
    remaining_steps = 4 - target_couple.received_meetup_feedbacks.count
    title = current_user.couple_profile.name
    case remaining_steps
    when 1..3
      notification_message = "Given you feedback, You are #{remaining_steps} steps from verification"
    when 0
      notification_message = "Given you feedback, You are now verified!"
    else
      notification_message = "Given you feedback"
    end
    data_hash = {notificationable_id: target_couple.id , notificationable_type: 'meetup_feedback'}
    trigger_meetup_notification(target_couple,data_hash,title,notification_message)
  end

  def accepted_meetup_feedback_notification(meetup)
    FillFeedbackJob.set(wait: fill_feedback_notify_time1.hours).perform_later(current_user.couple_profile,meetup)
    FillFeedbackJob.set(wait: fill_feedback_notify_time2.hours).perform_later(current_user.couple_profile,meetup)
  end

  def fill_feedback_notify_time1
    ApplicationConfig.configuration.fill_feedback_notify_time1_in_hours
  end

  def fill_feedback_notify_time2
    ApplicationConfig.configuration.fill_feedback_notify_time2_in_hours
  end
end