require 'enumerize'

class JeraPush::Device < ActiveRecord::Base
  extend Enumerize

  self.table_name = "jera_push_devices"

  belongs_to :pushable, polymorphic: true

  has_many :message_devices, class_name: "JeraPush::MessageDevice"
  has_many :messages, through: :message_devices, class_name: "JeraPush::Message"

  validates :token, :platform, presence: true
  validates :token, uniqueness: { scope: :platform }

  enumerize :platform, in: [:android, :ios, :chrome], predicate: true

  scope :ios,  -> { where(platform: :ios) }
  scope :android, -> { where(platform: :android) }
  scope :chrome, -> { where(platform: :chrome) }
  scope :with_joins, -> (resource_type) { joins("INNER JOIN #{resource_type.downcase.pluralize} ON  jera_push_devices.pushable_id = #{resource_type.downcase.pluralize}.id AND jera_push_devices.pushable_type  = '#{resource_type}'") }

end
