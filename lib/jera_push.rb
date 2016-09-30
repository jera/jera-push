require 'jera_push/engine'

module JeraPush
  class Engine < Rails::Engine; end

  autoload :Device, 'jera_push/models/device.rb'
  autoload :Message, 'jera_push/models/message.rb'
  autoload :MessageDevice, 'jera_push/models/message_device.rb'

  mattr_accessor :firebase_api_key
  @@firebase_api_key = nil

  def self.setup
    yield self
  end
end
