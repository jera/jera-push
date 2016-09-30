class JeraPush::Device < ActiveRecord::Base
  self.table_name = "jera_push_devices"
  has_many :messages, through: :message_devices
end
