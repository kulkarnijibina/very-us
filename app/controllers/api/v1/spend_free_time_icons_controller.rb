class Api::V1::SpendFreeTimeIconsController < ApiController

  skip_before_action :authenticate_user!

  def index
    spend_free_time_icons = SpendFreeTimeIcon.all
    unless spend_free_time_icons.empty?
      render_success_response({
                                spend_free_time_icons: array_serializer.new(spend_free_time_icons, serializer: Api::V1::SpendFreeTimeIconsSerializer)
                              }, 'spend free time icons', 200)
    else
      render_unprocessable_entity('There is no spend free time icons.')
    end
  end

end
