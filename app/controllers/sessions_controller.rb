# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  respond_to :json
  include ApplicationMethods
  skip_before_action :authenticate_user!, only: %i[login create], raise: false

  def create
    user = User.find_by(contact: params[:user][:contact])
    if user&.valid_password?(params[:user][:password])
      auth_token = JsonWebToken.encode({ user_id: user.id })
      render_success_response({
                                user: single_serializer.new(user, serializer: Api::V1::UserSerializer),
                                token: JsonWebToken.encode(user_id: user.id)
                              }, 'Login successful.', 200)
    else
      render_unprocessable_entity('Invalid username / password')
    end
  end

  def login
    user = User.find_by(contact: params[:user][:contact])
    if user&.valid_password?(params[:user][:password])
      auth_token = JsonWebToken.encode({ user_id: user.id })
      render_success_response({
                                user: single_serializer.new(user, serializer: Api::V1::UserSerializer),
                                token: JsonWebToken.encode(user_id: user.id)
                              }, 'Login successful.', 200)
    else
      render_unprocessable_entity('Invalid username / password')
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end
end
