require 'enumerize'

class JeraPush::Device < ActiveRecord::Base
  extend Enumerize

  self.table_name = "jera_push_devices"

  has_many :messages, through: :message_devices

  validates :token, :platform, presence: true

  enumerize :platform, in: [:android, :ios, :chrome], predicate: true

  scope :ios,  -> { where(platform: :ios) }
  scope :android, -> { where(platform: :android) }
  scope :chrome, -> { where(platform: :chrome) }

  def resources
    JeraPush.resource_name.classify.constantize
  end

  def send_message(message)
    JeraPush::Message.send message: message, devices: [ self ]
  end

  def subscribe(topic)
    client = JeraPush::Firebase::Client.instance
    client.add_device_to_topic(device: self, topic: topic)
  end

  def unsubscribe(topic)
    client = JeraPush::Firebase::Client.instance
    client.remove_device_from_topic(device: [self], topic: topic)
  end
end
