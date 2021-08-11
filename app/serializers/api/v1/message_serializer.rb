class Api::V1::MessageSerializer  < ActiveModel::Serializer
  attributes :message_id, :body, :read_status, :chat_id, :date, :couple_profile_id
  @hash ={}

  def read_status
    object&.is_mark_read
  end

  def message_id
    object&.id
  end

  def date
    object&.message_date
  end

  # def sender_detail
  #   u = object&.user
  #   return  @hash = {id: u&.id, name: "#{u&.primary_user&.first_name} & #{u&.secondary_user&.first_name}"}
  # end
end
