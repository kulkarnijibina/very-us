require 'plivo'
include Plivo

# SmsService.call(full_phone_number, message)
module SmsService
  AUTH_ID = ENV['auth_id']
  AUTH_TOKEN = ENV['auth_token']
  SOURCE_NUMBER = '+16042456670'

  class << self
    def call(full_phone_numbers, message)
      begin
        send_message(full_phone_numbers, message)
        {success: true}
      rescue Plivo::Exceptions::ValidationError => e
        {success: false, error:  "#{full_phone_numbers} Is Not A Valid Phone Number"}
      end
    end

    private
    def send_message(full_phone_numbers, message)
      plivo_client.messages.create(
        SOURCE_NUMBER,
        [*full_phone_numbers],
        message
      )
    end

    def plivo_client
      RestClient.new(AUTH_ID, AUTH_TOKEN)
    end
  end
end
