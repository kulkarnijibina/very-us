class Api::V1::ChatCoupleProifileSerializer < ActiveModel::Serializer
  attributes :id, :name, :profile_pic, :chat_availability, :is_partner_connected

  def name
  	object.name
  end

  def profile_pic
    Api::V1::ImageSerializer.new(object.profile_pic) if object.profile_pic
  end

  def is_partner_connected
    object.secondary_user.present?
  end
end
