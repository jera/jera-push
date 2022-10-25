require 'enumerize'

class JeraPush::Device < ActiveRecord::Base
  extend Enumerize

  DEFAULT_TOPIC = 'general'

  self.table_name = "jera_push_devices"

  has_many :message_devices, class_name: 'JeraPush::MessageDevice'
  has_many :messages, through: :message_devices, class_name: 'JeraPush::Message'

  belongs_to :pushable, polymorphic: true

  validates :token, :platform, presence: true
  validates :token, uniqueness: { scope: :platform }

  after_create :register_to_current_topic
  before_destroy :unregister_from_current_topic

  enumerize :platform, in: [:android, :ios, :chrome], predicate: true

  scope :ios,  -> { where(platform: :ios) }
  scope :android, -> { where(platform: :android) }
  scope :chrome, -> { where(platform: :chrome) }
  scope :with_joins, -> (resource_type) { joins("INNER JOIN #{resource_type.downcase.pluralize} ON  jera_push_devices.pushable_id = #{resource_type.downcase.pluralize}.id AND jera_push_devices.pushable_type  = '#{resource_type}'") }

  def send_message(message)
    JeraPush::Message.send_to self, content: message
  end

  def subscribe(topic)
    client = JeraPush::Firebase::Client.instance
    client.add_device_to_topic(topic: topic, device: self)
  end

  def unsubscribe(topic)
    client = JeraPush::Firebase::Client.instance
    client.remove_device_from_topic(topic: topic, devices: [self])
  end

  private

    def register_to_current_topic
      subscribe(JeraPush.send("topic_#{self.platform}"))
    end

    def unregister_from_current_topic
      unsubscribe(JeraPush.send("topic_#{self.platform}"))
    end
end
