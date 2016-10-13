class JeraPush::Message < ActiveRecord::Base
  self.table_name = "jera_push_messages"
  has_many :devices, through: :message_devices
  has_many :message_devices

  def self.send_to(target, content: {})
    return nil if target.blank? || content.blank?

    push_message = JeraPush::Message.create content: content
    push_message.devices << target

    if push_message && target.is_a?(JeraPush::Device)
      push_message.send_to_device device: target
    else
      push_message.send_to_devices devices: target
    end
    push_message
  end

  def content=(content)
    raise 'Invalid message format. Hash format expected' unless content.is_a? Hash

    super(content.to_json)
  end

  def content
    if super()
      JSON.parse(super())
    else
      return {}
    end
  end

  def send_to_devices(devices: [])
    return nil if devices.empty?
    platform_devices = devices.group_by { |device| device.platform }
    client = JeraPush::Firebase::Client.instance

    platform_devices.keys.each do |platform|
      payload = self.send("body_#{platform.to_s}", self.content)
      response = client.send_message(message: payload, devices: platform_devices[platform])
      if response
        response.result_to(message: self)
      end
    end
  end

  def send_to_device(device: nil)
    return nil if device.nil?

    payload = {}
    if device.platform.ios?
      payload = body_ios(self.content)
    elsif device.platform.android?
      payload = body_android(self.content)
    elsif device.platform.chrome?
      payload = body_chrome(self.content)
    end
    client = JeraPush::Firebase::Client.instance
    response = client.send_message(message: payload, devices: [device])
    if response
      response.result_to(message: self)
    end
  end

  private
  def body_ios(content)
    params = [:title, :body, :sound, :badge, :click_action, :body_loc_key, :body_loc_args, :title_loc_key, :title_loc_args]
    return {
      notification: content.select { |key, value| params.include?(key) },
      data: content.reject { |key, value| params.include?(key) }
    }
  end

  def body_android(content)
    return {
      data: content
    }
  end

  def body_chrome(content)
    return {
      data: content
    }
  end
end
