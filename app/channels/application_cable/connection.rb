module ApplicationCable
  class Connection < ActionCable::Connection::Base

    identified_by :current_user
    def connect
      authenticate_user!
      self.current_user = @current_user
      logger.add_tags 'ActionCable', current_user.id
    end

    private

    def authenticate_user!
      return invalid_authentication if !payload || !JsonWebToken.valid_payload(payload.first, token)

      load_current_user!
      invalid_authentication unless @current_user
    end

    # Returns 401 response. To handle malformed / invalid requests.
    def invalid_authentication
      reject_unauthorized_connection
    end

    private

    def token
      auth_header = request.params['Authorization']
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
end
