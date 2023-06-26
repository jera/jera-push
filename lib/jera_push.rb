require 'httparty'
require 'responders'
require 'jquery-rails'
require 'kaminari'
require 'jera_push/engine'
require 'jera_push/firebase/client'
require 'jera_push/firebase/api_result'
require 'jera_push/services/base_service'
require 'jera_push/services/send_message_to_user_service'

module JeraPush
  autoload :Device, 'jera_push/models/device.rb'
  autoload :Message, 'jera_push/models/message.rb'
  autoload :MessageDevice, 'jera_push/models/message_device.rb'
  autoload :DeviceFilter, 'jera_push/models/device_filter.rb'

  mattr_accessor :firebase_api_key
  @@firebase_api_key = nil

  mattr_accessor :default_topic
  @@default_topic = 'jera_push_development'

  mattr_accessor :resource_name
  @@resource_name = nil

  mattr_accessor :resource_attributes
  @@resource_attributes = []

  mattr_accessor :admin_login
  @@resource_name =  { username: 'jera_push', password: 'JeraPushAdmin' }


  def self.setup
    yield self
  end

  def self.topic_android
    @@android_topic ||= "#{@@default_topic}_android"
  end

  def self.topic_ios
    @@ios_topic ||= "#{@@default_topic}_ios"
  end

  def self.topic_chrome
    @@chrome_topic ||= "#{@@default_topic}_chrome"
  end
end
