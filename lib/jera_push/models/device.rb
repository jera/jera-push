require 'enumerize'

class JeraPush::Device < ActiveRecord::Base
  extend Enumerize

  self.table_name = "jera_push_devices"

  belongs_to :resource, class_name: JeraPush.resource_name

  has_many :message_devices, class_name: "JeraPush::MessageDevice"
  has_many :messages, through: :message_devices, class_name: "JeraPush::Message"

  validates :token, :platform, presence: true
  validates :token, uniqueness: { scope: :platform }

  enumerize :platform, in: [:android, :ios], predicate: true

  after_create :subscribe_to_topic
  before_destroy :unsubscribe_to_topic

  scope :ios, -> {
    where(platform: :ios)
  }

  scope :android, -> {
    where(platform: :android)
  }

  private

  def subscribe_to_topic
    JeraPush::Services::TopicService.new.subscribe(
      device: self,
      topic: JeraPush.send("topic_#{platform}")
    )
  end

  def unsubscribe_to_topic
    JeraPush::Services::TopicService.new.unsubscribe(
      device: self,
      topic: JeraPush.send("topic_#{platform}")
    )
  end

end
