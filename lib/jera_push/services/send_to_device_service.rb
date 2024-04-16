module JeraPush::Services
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

      @message
    end

    private

    def validate_device
      @errors.add(:base, message: I18n.t('jera_push.services.errors.not_found.device')) if @device.blank?
    end

    def create_message
      @message = JeraPush::Message.create(title: @title, body: @body, data: data_params)
    end

    def add_devices_to_message
      @message_device = @message.message_devices.create(device: @device)
    end

    def send_push
      JeraPush::Services::SendPushService.new(device: @device, 
        message: @message, 
        message_device: @message_device,
        ios_config: @ios_config,
        android_config: @android_config
      ).call
    end
  
    def data_params
      @data.merge({ title: @title, body: @body })
    end
  end
end
