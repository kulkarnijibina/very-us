class Api::V1::SplashScreenImageSerializer < ActiveModel::Serializer
  attributes :id, :uri, :height, :width

  def uri
  	object.image.service_url
  end

end
