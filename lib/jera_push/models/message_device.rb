class JeraPush::MessageDevice < ActiveRecord::Base
  self.table_name = "jera_push_messages_devices"

  belongs_to :device
  belongs_to :message

  has_one :resource, through: :device

end
