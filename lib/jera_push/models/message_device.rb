require 'enumerize'
class JeraPush::MessageDevice < ActiveRecord::Base
  extend Enumerize
  self.table_name = "jera_push_messages_devices"

  belongs_to :device
  belongs_to :message

  enumerize :status, in: [:error, :success], predicate: true

  has_one :pushable, through: :device
end
