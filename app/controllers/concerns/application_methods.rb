# frozen_string_literal: true

module ApplicationMethods
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :handle_internal_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  end

    private

  def handle_internal_server_error(exception)
    raise unless request.format.json?

    errors = [exception.message, *exception.backtrace].join($/)
    log_error errors
    render_json_error(:internal_server_error, :internal_server_error, errors)
  end

  def render_json_error(status, error_code, errors, message = nil)
    message ||= I18n.t("errors.#{error_code}")
    json_response({ success: false, message: message, error_code: error_code, errors: errors }, status)
  end

  def record_not_found(exception)
    raise unless request.format.json?

    errors = [exception.message, *exception.backtrace].join($/)
    log_error errors
    render_json_error(:not_found, :record_not_found, errors)
  end

  def render_unprocessable_entity_response(resource)
    json_response({
                    success: false,
                    message: ValidationErrorsSerializer.new(resource).serialize[0][:message],
                    errors: ValidationErrorsSerializer.new(resource).serialize
                  }, 200)
  end

  def render_unprocessable_entity(message, data=nil, error_code=nil)
    json_response({
                    success: false,
                    message: message,
                    data: data,
                    error_code: error_code,
                  }, 200) and return true
  end

  def render_success_response(resources = {}, message = '', status = 200, meta = {})
    json_response({
                    success: true,
                    message: message,
                    data: resources,
                    meta: meta
                  }, status)

  end

  def render_message(message = '', status = 200)
    json_response({
                    success: true,
                    message: message
                  }, status)
  end

  def json_response(options = {}, status = 500)
    render json: JsonResponse.new(options), status: status
  end

  def render_unauthorized_response
    json_response({
                    success: false,
                    message: 'Your session has expired, please login to continue.',
                    error_code: :session_expired
                  }, 401)
  end

  def render_deactivated_response
    json_response({
                    success: false,
                    message: 'Sorry, your profile is deactivated.',
                    error_code: :user_deactivated
                  }, 401)
  end

  def array_serializer
    ActiveModel::Serializer::CollectionSerializer
  end

  def single_serializer
    ActiveModelSerializers::SerializableResource
  end

  def log_error(message)
    Rails.logger.error(message)
    error_logger.error(message)
  end

  def error_logger
    @@error_logger ||= Logger.new("#{Rails.root}/log/error.log")
  end

  def location_logger
    @@logger ||= Logger.new("#{Rails.root}/log/location.log")
  end
end
