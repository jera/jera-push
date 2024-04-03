module JeraPush::Services
  class SendToDevicesService < JeraPush::Services::BaseService
    def initialize(devices:, title:, body:, data:, android: {}, ios: {})
      super
      @devices = devices
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
      send_push_to_devices

      @message
    end

    private

    def validate_device
      @errors.add(:base, message: I18n.t('jera_push.services.errors.not_found.device')) if @devices.empty?
    end

    def create_message
      @message = JeraPush::Message.create(title: @title, body: @body, data: data_params)
    end

    def send_push_to_devices
      @devices.each do |device|
        message_device = @message.message_devices.create(device: device)
        send_push(device, message_device)
      end
    end

    def send_push(device, message_device)
      JeraPush::Services::SendPushService.new(device: device, 
        message: @message, 
        message_device: message_device,
        ios_config: @ios_config,
        android_config: @android_config
      ).call
    end

    def data_params
      @data.merge({ title: @title, body: @body })
    end
  end
end
