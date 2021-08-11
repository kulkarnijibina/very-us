# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode(payload, ENV['SECRET_KEY_BASE'])
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    JWT.decode(token, ENV['SECRET_KEY_BASE'])
  end

  # Add user token in JWT Allow List
  def self.add_token(user, token)
    user.jwt_allow_list.destroy if user.jwt_allow_list
    JwtAllowList.create(jti: token, user: user)
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload, token)
    user = User.find_by(id: payload['user_id'])
    return false unless user && user.jwt_allow_list.present?
    if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud] || token != user.jwt_allow_list.jti
      false
    else
      true
    end
  end

  # Default options to be encoded in the token
  def self.meta
    {
      exp: 7.days.from_now.to_i,
      iss: 'issuer_name',
      aud: 'client'
    }
  end

  # Validates if the token is expired by exp parameter
  def self.expired(payload)
    Time.at(payload['exp']) < Time.now
  end
end
