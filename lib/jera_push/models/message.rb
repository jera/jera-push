require 'enumerize'

class JeraPush::Message < ActiveRecord::Base
  extend Enumerize
  self.table_name = "jera_push_messages"

  has_many :devices, through: :message_devices
  has_many :message_devices

  serialize :broadcast_result

  enumerize :kind, in: [:broadcast, :specific], predicate: true, default: :specific

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

  def self.send_broadcast(content:)
    return nil if content.blank?

    push_message = JeraPush::Message.create content: content, kind: :broadcast

    results = []
    results << to_android_topic(push_message)
    results << to_ios_topic(push_message)
    results << to_chrome_topic(push_message)

    ApiResult.broadcast_result(message: push_message, results: results)
    push_message
  end

  def self.send_to_topic(topic: , content: {})
    return nil if topic.blank? || content.blank?

    push_message = JeraPush::Message.create content: content, topic: topic
    client = JeraPush::Firebase::Client.instance
    response = client.send_message_to_topic(message: { data: content }, topic: topic)
    response.topic_result(message: push_message)
    push_message
  end

  def self.format_hash(messages = [])
    return false if messages.blank?
    messages.collect do |obj|
      hash = { obj[:key].to_sym => obj[:value] }
      hash.delete_if { |key, value| key.blank? || value.blank? }
    end.reduce(:merge)
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

    def to_android_topic(content)
      @client ||= JeraPush::Firebase::Client.instance

      client.send_message_to_topic(
        message: body_android(content),
        topic: JeraPush.topic_android
      )
    end

    def to_ios_topic(content)
      @client ||= JeraPush::Firebase::Client.instance

      client.send_message_to_topic(
        message: body_ios(content),
        topic: JeraPush.topic_ios
      )
    end

    def to_chrome_topic(content)
      @client ||= JeraPush::Firebase::Client.instance

      client.send_message_to_topic(
        message: body_chrome(content),
        topic: JeraPush.topic_chrome
      )
    end

    def body_ios(content)
      params = [:title, :body, :sound, :badge, :click_action, :body_loc_key, :body_loc_args, :title_loc_key, :title_loc_args]

      content.symbolize_keys!
      content[:sound] = 'default' unless content.has_key?(:sound)

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
