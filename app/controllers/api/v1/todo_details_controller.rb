class Api::V1::TodoDetailsController < ApiController
  def index
    todo_details = CalculateAllTodosService.call(current_user)
    unless todo_details.empty?
      render_success_response({todo_details: serialize_todos(todo_details)}, 'todo details details', 200)
    else
      render_unprocessable_entity('There is no todo details details')
    end
  end

  private
  def serialize_todos(todo_details)
    todos = todo_details.where.not(name: exceptional_todos)
    serialized_todos = array_serializer.new(todos, serializer: Api::V1::TodoDetailsSerializer)
    serialized_exp_todos = serialize_exceptional_todos(todo_details.where(name: exceptional_todos))
    raw_todos = serialized_todos.to_a + serialized_exp_todos.to_a
    sort_todos(raw_todos)
  end

  def serialize_exceptional_todos(todos)
    todos.map do |todo|
      case todo.name
      when 'meetup_feedback'
        current_user.couple_profile.pending_feedback_meetups.map do |pending_feedback_meetup|
          recipient = pending_feedback_meetup.other_couple(current_user.couple_profile)
          image_url = recipient.profile_pic_url
          single_serializer.new(todo, serializer: Api::V1::TodoDetailsSerializer).as_json.merge(
            data: {id: pending_feedback_meetup.id},
            title: recipient.name,
            description: "Meetup Attended on #{pending_feedback_meetup.date_time.strftime("%d-%m-%Y")}",
            image_url: image_url
          )
        end
      when 'reminder_to_respond_to_meeting_invite'
        current_user.couple_profile.received_pending_meetups.limit(2).map do |meetup|
          recipient = meetup.other_couple(current_user.couple_profile)
          image_url = recipient.profile_pic_url
          single_serializer.new(todo, serializer: Api::V1::TodoDetailsSerializer).as_json.merge(
            data: ChatAndMeetupSerializerService.meetup_serializer(meetup).merge(target_couple_id: recipient.id, couple_name: recipient.name),
            title: recipient.name,
            description: "You have a meeting invite",
            image_url: image_url,
            current_user_profile_pic: current_user.couple_profile.profile_pic_url
          )
        end
      when 'respond_to_any_and_all_new_interactions'
        current_user.couple_profile.unread_chats.limit(2).map do |chat|
          recipient = chat.other_couple(current_user.couple_profile)
          image_url = recipient.profile_pic_url
          single_serializer.new(todo, serializer: Api::V1::TodoDetailsSerializer).as_json.merge(
            data: {chat_id: chat.id, target_couple_id: recipient.id, couple_name: recipient.name},
            title: recipient.name,
            description: chat.messages.order(:created_at).last.body,
            image_url: image_url
          )
        end
      when 'upcoming_meetup'
        current_user.couple_profile.upcoming_meetups.map do |meetup|
          recipient = meetup.other_couple(current_user.couple_profile)
          image_url = recipient.profile_pic_url
          single_serializer.new(todo, serializer: Api::V1::TodoDetailsSerializer).as_json.merge(
            data: ChatAndMeetupSerializerService.meetup_serializer(meetup),
            title: recipient.name,
            description: "You have an upcoming meetup",
            image_url: image_url,
            current_user_profile_pic: current_user.couple_profile.profile_pic_url
          )
        end
      end
    end.flatten
  end

  def sort_todos(raw_todos)
    raw_todos.as_json.sort_by{|raw_todo| priority[raw_todo["name"]] || 1000 }
  end

  def exceptional_todos
    [
      'meetup_feedback',
      'reminder_to_respond_to_meeting_invite',
      'respond_to_any_and_all_new_interactions',
      'upcoming_meetup'
    ]
  end

  def priority
    {
      'upcoming_meetup' => 1,
      "reminder_to_respond_to_meeting_invite" => 2,
    }
  end
end
