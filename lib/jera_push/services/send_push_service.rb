module JeraPush::Services
  class SendPushService < JeraPush::Services::BaseService
    def initialize(push:, message:, message_device:)
      super
      @push = push
      @message = message
      @message_device = message_device
    end

    def call
      return @errors if @errors.present?

      send_push

      @message
    end

    private

    def send_push
      @response = @firebase.send_to_device(push: @push)
      save_success
    rescue Google::Apis::AuthorizationError => e
      message = JSON.parse(e.body)
      save_error(message)
    rescue Google::Apis::ClientError => e
      response = JSON.parse(e.body, symbolize_names: true)
      error_code = response[:error][:details][0][:errorCode]
      save_error(response)
    end

    def save_success
      @message_device.update(status: :success)
      @message.update(success_count: @message.success_count + 1)
    end

    def save_error(error)
      @message_device.update(status: :error, error_message: error.to_json)
      @message.update(failure_count: @message.failure_count + 1)
    end
  end
end
