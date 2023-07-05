module JeraPush::Services::Message
  class SendToUserService < JeraPush::Services::BaseService
    def initialize(user:, title:, body:)
      super
      @user = user
      @title = title
      @body = body
    end

    def call
      fetch_devices

      return @errors if @errors.present?

      create_message
      add_devices_to_message
      send_push
      update_message

      @message
    end

    private

    def fetch_devices
      @devices = @user.devices

      @errors.add(:base, message: I18n.t('jera_push.services.errors.not_found.device')) if @devices.blank?
    end

    def create_message
      @message = JeraPush::Message.create(title: @title, body: @body)
    end

    def add_devices_to_message
      @devices.each do |device|
        @message.message_devices.create(device: device)
      end
    end

    def send_push
      @response = @firebase.send_to_devices(message: @message)
    end

    def update_message
      @message.update(
        multicast_id: @response["multicast_id"],
        success_count: @response["success"],
        failure_count: @response["failure"]
      )
    end

  end
end
