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

  scope :ios, -> {
    where(platform: :ios)
  }

  scope :android, -> {
    where(platform: :android)
  }
end
