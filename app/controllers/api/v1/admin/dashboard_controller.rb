class Api::V1::Admin::DashboardController < ApiController
  # skip_before_action :authenticate_user!

  def user_detail
    render_success_response(user_detail: single_serializer.new(@current_user, serializer: Api::V1::Admin::DashboardSerializer))
  end
end
