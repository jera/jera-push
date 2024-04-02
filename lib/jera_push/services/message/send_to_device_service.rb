module JeraPush::Services::Message
  class SendToDeviceService < JeraPush::Services::BaseService
    def initialize(device:, title:, body:, data:, android: {}, ios: {})
      super
      @device = device
      @title = title
      @body = body
      @data = data
      @android_config = android
      @ios_config = ios
    end

    def call
      validate_device

      return @errors if @errors.present?

      create_message
      add_devices_to_message
      send_push
      update_message

      @message
    end

    private

    def validate_device
      @errors.add(:base, message: I18n.t('jera_push.services.errors.not_found.device')) if @device.blank?
    end

    def create_message
      @message = JeraPush::Message.create(title: @title, body: @body)
    end

    def add_devices_to_message
      @message.message_devices.create(device: device)
    end

    def send_push
      @response = @firebase.send_to_devices(message: message_params(device))
    end

    def update_message
      @message.update(
        multicast_id: @response["multicast_id"],
        success_count: @response["success"],
        failure_count: @response["failure"]
      )
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
          data: data_params,
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
          data: data_params,
          apns: apns_params
        },
        validate_only: false
      }
    end

    def notification
      { title: @message.title, body: @message.body }
    end
  
    def data_params
      @data.merge({ title: @title, body: @body })
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
