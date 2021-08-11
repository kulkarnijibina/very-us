# frozen_string_literal: true

class JsonResponse
  attr_reader :success, :message, :data, :meta, :errors, :error_code

  def initialize(options = {})
    @success = options[:success].to_s.empty? ? true : options[:success]
    @message = options[:message] || ''
    @error_code = options[:error_code]
    @data = options[:data] || {}
    @meta = options[:meta] || {}
    @errors = options[:errors] || []
  end

  def as_json(*)
    {
      success: success,
      message: message,
      error_code: error_code,
      data: data,
      meta: meta,
      errors: errors
    }
  end
  end
