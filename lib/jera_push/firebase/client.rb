module JeraPush
  module Firebase
    class Client

      cattr_accessor :client

      FIREBASE_URL = "https://fcm.googleapis.com/fcm/send"
      FIREBASE_INSTANCE_ID_URL = "https://iid.googleapis.com/iid"
      
      @instance = new

      private_class_method :new

      def self.instance
        @instance
      end

      def send_message(message:, devices: [])
        send(
          url: FIREBASE_URL,
          body: { registration_ids: devices.map(&:token), priority: 'high' }.merge!(message).to_json
        )
      end

      def send_message_to_topic(message:, topic:)
        send(
          url: FIREBASE_URL,
          body: { to: "/topics/#{topic}", priority: 'high' }.merge!(message).to_json
        )
      end

      def device_details(device:)
        send(
          url: "#{FIREBASE_INSTANCE_ID_URL}/info/#{device.token}/",
          body: {}.to_json
        )
      end

      def add_device_to_topic(topic:, device:)
        send(
          url: "#{FIREBASE_INSTANCE_ID_URL}/v1/#{device.token}/rel/topics/#{topic}",
          body: {}.to_json
        )
      end

      def add_devices_to_topic(topic:, devices: [])
        send(
          url: "#{FIREBASE_INSTANCE_ID_URL}/v1:batchAdd",
          body: {
            "to": "/topics/#{topic}",
            "registration_tokens": devices.map(&:token),
          }.to_json
        )
      end

      def remove_device_from_topic(topic:, devices: [])
        send(
          url: "#{FIREBASE_INSTANCE_ID_URL}/v1:batchRemove",
          body: {
            "to": "/topics/#{topic}",
            "registration_tokens": devices.map(&:token),
          }.to_json
        )
      end

      private

      def send(url:, body:)
        response = HTTParty.post(url, { body: body, headers: default_headers })

        ApiResult.new(response)
      end

      def default_headers
        {
          "Authorization" => "key=#{::JeraPush.firebase_api_key}",
          "Content-Type" => "application/json"
        }
      end

    end
  end
end