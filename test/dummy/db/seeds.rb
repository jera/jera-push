module Populate
  USER_COUNT = 30
  DEVICES_PER_USER = 2
  MESSAGES_COUNT = 10000

  def self.run_users
    return nil unless USER_COUNT

    users = []
    USER_COUNT.times { users << {name: Faker::Name.name} }

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
            user_id: user.id,
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
        content: { title: Faker::Lorem.sentence(3), text: Faker::Hacker.say_something_smart },
        status: :sent
      }
    end

    ActiveRecord::Base.transaction { JeraPush::Message.create messages }
  end
end

Populate.run_users
Populate.run_devices
Populate.run_push_messages
