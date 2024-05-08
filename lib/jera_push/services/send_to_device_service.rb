module JeraPush::Services
  class SendToDeviceService < JeraPush::Services::BaseService
    def initialize(push:)
      super
      @push = push
      @device = @push.device
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
      @message = JeraPush::Message.create(title: @push.notification.title, body: @push.notification.body, data: @push.data)
    end

    def add_devices_to_message
      @message_device = @message.message_devices.create(device: @device)
    end

    def send_push
      JeraPush::Services::SendPushService.new(push: @push,
        message: @message,
        message_device: @message_device
      ).call
    end
  end
end
