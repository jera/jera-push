module JeraPush::Services
  class SendToDevicesService < JeraPush::Services::BaseService
    def initialize(push:)
      super
      @push = push
      @devices = @push.devices
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
      @message = JeraPush::Message.create(title: @push.notification.title, body: @push.notification.body)
    end

    def send_push_to_devices
      @devices.each do |device|
        @message_device = @message.message_devices.create(device: device)
        @push.device = device
        send_push
      end
    end

    def send_push
      JeraPush::Services::SendPushService.new(push: @push,
        message: @message,
        message_device: @message_device
      ).call
    end
  end
end
