class Api::V1::SplashScreensController < ApiController

	skip_before_action :authenticate_user!

  def index
    splash_screens = SplashScreen.order(priority: :desc)
    unless splash_screens.empty?
      render_success_response({
                                splash_screens: array_serializer.new(splash_screens, serializer: Api::V1::SplashScreenSerializer)
                              }, 'splash_screens details', 200)
    else
      render_unprocessable_entity('There is no splash_screens details')
    end
  end
end
