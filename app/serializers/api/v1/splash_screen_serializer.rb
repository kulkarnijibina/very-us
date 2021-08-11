class Api::V1::SplashScreenSerializer < ActiveModel::Serializer
  require "mini_magick"
  attributes :id, :title, :text1, :text2, :text3, :images, :background_color

  def images
    ActiveModel::Serializer::CollectionSerializer.new(object.splash_screen_images, serializer: Api::V1::SplashScreenImageSerializer)
  end
  
end
