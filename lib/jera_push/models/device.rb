require 'enumerize'

class JeraPush::Device < ActiveRecord::Base
  extend Enumerize

  DEFAULT_TOPIC = 'general'

  self.table_name = "jera_push_devices"

  has_many :messages, through: :message_devices, class_name: "jera_push_messages"
  has_many :message_devices, class_name: "jera_push_message_devices"

  belongs_to :resource, class_name: JeraPush.resource_name

  validates :token, :platform, presence: true
  validates :token, uniqueness: { scope: :platform }

  enumerize :platform, in: [:android, :ios], predicate: true

  scope :ios, -> {
    where(platform: :ios)
  }

  scope :android, -> {
    where(platform: :android)
  }

end
