class JeraPush::Device < ActiveRecord::Base
  extend Enumerize

  self.table_name = "jera_push_devices"

  has_many :messages, through: :message_devices

  validates :token, :platform, presence: true

  enumerize :platform, in: [:android, :ios, :chrome]
end
