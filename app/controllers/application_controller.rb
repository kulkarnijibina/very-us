# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user!
  # require 'json_web_token'
  # include ApplicationMethods
  # include ActionView::Layouts

  # # before_action :authenticate_user!

  # def render_resource(resource)
  #   if resource.errors.empty?
  #     render json: resource
  #   else
  #     validation_error(resource)
  #   end
  # end

  # def after_sign_out_path_for(_resource_or_scope)
  #   root_path
  # end

  # def validation_error(resource)
  #   render json: {
  #     errors: [
  #       {
  #         status: '400',
  #         title: 'Bad Request',
  #         detail: resource.errors,
  #         code: '100'
  #       }
  #     ]
  #   }, status: :bad_request
  # end

  # protected

  # # Validates the token and user and sets the @current_user scope
  # def authenticate_user!
  #   return invalid_authentication if !payload || !JsonWebToken.valid_payload(payload.first)

  #   load_current_user!
  #   invalid_authentication unless @current_user
  # end

  # # Returns 401 response. To handle malformed / invalid requests.
  # def invalid_authentication
  #   render_unauthorized_response
  # end

  # private

  # # Deconstructs the Authorization header and decodes the JWT token.
  # def payload
  #   auth_header = request.headers['Authorization']
  #   token = auth_header.split(' ').last
  #   JsonWebToken.decode(token)
  # rescue StandardError
  #   nil
  # end

  # # Sets the @current_user with the user_id from payload
  # def load_current_user!
  #   @current_user = User.find_by(id: payload[0]['user_id'])
  # end
end
