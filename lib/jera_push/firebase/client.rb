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

      def send_to_devices(message:)
        send(
          url: FIREBASE_URL,
          body: {
            title: message.title,
            body: message.body,
            registration_ids: message.devices.pluck(:token),
            priority: 'high'
          }
        )
      end

      private

      def send(url:, body:)
        JSON.parse(HTTParty.post(url, { body: body, headers: default_headers }))
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
