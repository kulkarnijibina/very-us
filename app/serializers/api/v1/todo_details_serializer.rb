class Api::V1::TodoDetailsSerializer < ActiveModel::Serializer
  attributes :id, :name, :title,:description, :image_url

  def image_url
    object.image.service_url if object.image.attached?
  end
end
