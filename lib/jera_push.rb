require 'httparty'
require 'responders'
require 'jquery-rails'
require 'kaminari'
require 'jera_push/engine'
require 'jera_push/firebase/client'
require 'jera_push/firebase/api_result'
require 'googleauth'
require 'google/apis/fcm_v1'

require 'jera_push/services/base_service'
require 'jera_push/services/send_message'
require 'jera_push/services/send_push_service'
require 'jera_push/services/send_to_device_service'
require 'jera_push/services/send_to_devices_service'
require 'jera_push/services/send_to_everyone_service'
require 'jera_push/services/send_to_topic_service'
require 'jera_push/services/topic_service'

module JeraPush
  autoload :Device, 'jera_push/models/device.rb'
  autoload :Message, 'jera_push/models/message.rb'
  autoload :MessageDevice, 'jera_push/models/message_device.rb'
  autoload :DeviceFilter, 'jera_push/models/device_filter.rb'
  autoload :PushBody, 'jera_push/models/push_body.rb'
  autoload :AppleConfig, 'jera_push/models/apple_config.rb'
  autoload :AndroidConfig, 'jera_push/models/android_config.rb'
  autoload :Notification, 'jera_push/models/notification.rb'

  mattr_accessor :project_id
  @@project_id = nil

  mattr_accessor :project_id
  @@project_id = nil

  mattr_accessor :default_topic
  @@default_topic = 'jera_push_development'

  mattr_accessor :resources_name
  @@resources_name = nil

  mattr_accessor :credentials_path
  @@credentials_path = nil

  mattr_accessor :resource_attributes
  @@resource_attributes = []

  mattr_accessor :admin_login
  @@resources_name =  { username: 'jera_push', password: 'JeraPushAdmin' }

  def self.setup
    yield self
  end

  def self.topic_android
    @@android_topic ||= "#{@@default_topic}_android"
  end

  def self.topic_ios
    @@ios_topic ||= "#{@@default_topic}_ios"
  end

end
