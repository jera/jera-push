require 'enumerize'

class JeraPush::Message < ActiveRecord::Base
  extend Enumerize

  self.table_name = "jera_push_messages"

  has_many :message_devices
  has_many :devices, through: :message_devices

  enumerize :kind, in: [:specific, :everyone, :topic], predicate: true, default: :specific

end
