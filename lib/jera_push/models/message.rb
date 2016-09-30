class JeraPush::Message < ActiveRecord::Base
  self.table_name = "jera_push_messages"
  has_many :devices, through: :message_devices
  has_many :message_devices
end
