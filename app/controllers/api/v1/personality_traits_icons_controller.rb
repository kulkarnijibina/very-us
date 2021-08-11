class Api::V1::PersonalityTraitsIconsController < ApiController

  skip_before_action :authenticate_user!

  def index
    personality_traits_icons = PersonalityTraitsIcon.all
    unless personality_traits_icons.empty?
      render_success_response({
                                personality_traits_icons: array_serializer.new(personality_traits_icons, serializer: Api::V1::PersonalityTraitsIconsSerializer)
                              }, 'personality traits icons', 200)
    else
      render_unprocessable_entity('There is no personality traits icons.')
    end
  end

end
