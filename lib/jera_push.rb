require 'httparty'
require 'kaminari'
require 'jera_push/engine'
require 'jera_push/firebase/client'
require 'jera_push/firebase/api_result'

module JeraPush

  autoload :Device, 'jera_push/models/device.rb'
  autoload :Message, 'jera_push/models/message.rb'
  autoload :MessageDevice, 'jera_push/models/message_device.rb'

  mattr_accessor :firebase_api_key
  @@firebase_api_key = nil

  mattr_accessor :resource_name
  @@resource_name = nil

  mattr_accessor :resource_attributes
  @@resource_attributes = []

  def self.setup
    yield self
  end
end
