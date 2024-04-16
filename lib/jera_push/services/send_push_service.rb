module JeraPush::Services
  class SendPushService < JeraPush::Services::BaseService
    def initialize(device:, message:, message_device:, android_config: {}, ios_config: {})
      super
      @device = device
      @message = message
      @message_device = message_device
      @android_config = android_config
      @ios_config = ios_config
    end

    def call
      return @errors if @errors.present?

      send_push

      @message
    end

    private

    def send_push
      @response = @firebase.send_to_device(message: message_params(@device))
      @message_device.update(status: :success)
      @message.update(success_count: @message.success_count + 1)
    rescue Google::Apis::AuthorizationError => e
      message = JSON.parse(e.body)
      @message_device.update(status: :error, error_message: message.to_json)
      @message.update(failure_count: @message.failure_count + 1)
    rescue Google::Apis::ClientError => e
      response = JSON.parse(e.body, symbolize_names: true)
      error_code = response[:error][:details][0][:errorCode]
      @message_device.update(status: :error, error_message: response.to_json)
      @message.update(failure_count: @message.failure_count + 1)
    end

    # Documentação com o atributos que podem ser usados em { message: }
    # https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br
    def message_params(device)
      case device.platform.to_sym
      when :android
        android_params(device.token)
      when :ios
        ios_params(device.token)
      else
        {}
      end
    end

    def android_params(token)
      {
        message: {
          token: token,
          notification: notification,
          data: @message.data,
          android: android_configs
        },
        validate_only: false
      }
    end
  
    def ios_params(token)
      {
        message: {
          token: token,
          notification: notification,
          data: @message.data,
          apns: apns_params
        },
        validate_only: false
      }
    end

    def notification
      { title: @message.title, body: @message.body }
    end

    def apns_params
      @ios_config.empty? ? default_apns_params : @ios_config
    end

    def android_configs
      @android_config.merge({ priority: 'high'})
    end

    def default_apns_params
      {
        headers: {
          'apns-priority': '5'
        },
        payload: {
          aps: {
            'content-available': 1
          }
        }
      }
    end
  end
end
