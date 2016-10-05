class JeraPush::Message < ActiveRecord::Base
  self.table_name = "jera_push_messages"
  has_many :devices, through: :message_devices
  has_many :message_devices

  def self.send_to(target, message: {})
    return nil if target.blank? || message.blank?

    push_message = JeraPush::Message.create message: message

    if push_message && target.is_a?(JeraPush::Device)
      push_message.send_to_device device: target
    else
      push_message.send_to_devices devices: target
    end
  end

  def message=(message)
    raise 'Invalid message format. Hash format expected' unless message.is_a? Hash

    super(message.to_json)
  end

  def message
    JSON.parse(super()) if super()
  end

  def send_to_devices(devices: [])
    return nil if devices.empty?
    platform_devices = devices.group_by { |device| device.platform }
    client = JeraPush::Firebase::Client.instance

    platform_devices.keys.each do |platform|
      payload = self.send("body_#{platform.to_s}", self.message)
      client.send_message(message: payload, devices: platform_devices[platform])
    end
  end

  def send_to_device(device: nil)
    return nil if device.nil?
    payload = self.message
    if device.platform.ios?
      payload = body_ios(self.message)
    elsif device.platform.android?
      payload = body_android(self.message)
    elsif device.platform.chrome?
      payload = body_chrome(self.message)
    end
    client = JeraPush::Firebase::Client.instance
    client.send_message(message: payload, devices: [device])
  end

  private
  def body_ios(message)
    params = [:title, :body, :sound, :badge, :click_action, :body_loc_key, :body_loc_args, :title_loc_key, :title_loc_args]
    return {
      notification: message.select { |key, value| params.include?(key) },
      data: message.reject { |key, value| params.include?(key) }
    }
  end

  def body_android(message)
    return {
      data: message
    }
  end

  def body_chrome(message)
    return {
      data: message
    }
  end
end
