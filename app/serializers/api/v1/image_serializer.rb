class Api::V1::ImageSerializer < ActiveModel::Serializer
  attributes :image_url, :id, :is_profile_pic

  def image_url
    object.image.service_url  if object.image.attached?
  end
end
