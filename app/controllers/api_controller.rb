class ApiController < ActionController::API
  # protect_from_forgery with: :null_session
  
  before_action :authenticate_user!

  require 'json_web_token'
  include ApplicationMethods
  include ActionView::Layouts


  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end

  def current_user
    load_current_user!
  end

  protected

  # Validates the token and user and sets the @current_user scope
  def authenticate_user!
    return invalid_authentication if !payload || !JsonWebToken.valid_payload(payload.first, token)

    load_current_user!
    if @current_user
      return invalid_authentication_for_deactivated unless @current_user.couple_profile.active?
    end
    invalid_authentication unless @current_user
  end

  # Returns 401 response. To handle malformed / invalid requests.
  def invalid_authentication
    render_unauthorized_response
  end

  def invalid_authentication_for_deactivated
    render_deactivated_response
  end

  private

  def token
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    rescue StandardError
    nil
  end

  # Deconstructs the Authorization header and decodes the JWT token.
  def payload
    JsonWebToken.decode(token)
  rescue StandardError
    nil
  end

  # Sets the @current_user with the user_id from payload
  def load_current_user!
    @current_user = User.find_by(id: payload[0]['user_id']) if payload.present?
  end
end