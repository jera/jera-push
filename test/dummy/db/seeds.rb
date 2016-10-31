module Populate
  USER_COUNT = 30
  DEVICES_PER_USER = 2
  MESSAGES_COUNT = 10
  MESSAGES_PER_DEVICE = 6

  def self.run_users
    return nil unless USER_COUNT

    users = []
    USER_COUNT.times { users << { name: Faker::Name.name, email: Faker::Internet.email} }

    ActiveRecord::Base.transaction { User.create users }
  end

  def self.run_devices
    return nil unless DEVICES_PER_USER || User.any?

    devices = []
    User.all.each do |user|
      platforms = [:ios, :chrome, :android].shuffle
      DEVICES_PER_USER.times do
          devices << {
            token: Faker::Crypto.sha256,
            resource_id: user.id,
            platform: platforms.pop
          }
      end
    end

    ActiveRecord::Base.transaction { JeraPush::Device.create devices }
  end

  def self.run_push_messages
    return nil unless JeraPush::Device.any? || MESSAGES_PER_DEVICE

    messages = []
    MESSAGES_COUNT.times do
      messages << {
        content: { title: Faker::Lorem.sentence(3), body: Faker::Hacker.say_something_smart },
        status: :sent
      }
    end

    ActiveRecord::Base.transaction { JeraPush::Message.create messages }
  end

  def self.run_message_devices
    return false if JeraPush::Message.blank? || JeraPush::Device.blank?

    device_ids = JeraPush::Device.all.pluck(:id)
    message_ids = JeraPush::Message.all.pluck(:id)
    message_devices = []

    message_ids.each do |message_id|
      MESSAGES_PER_DEVICE.times do
        record = { device_id: device_ids.sample, message_id: message_id }
        message_devices << record unless message_devices.include? record
      end
    end

    ActiveRecord::Base.transaction { JeraPush::MessageDevice.create message_devices }

  end
end

Populate.run_users
Populate.run_devices
Populate.run_push_messages
Populate.run_message_devices
