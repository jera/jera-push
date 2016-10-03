module JeraPush
  module Firebase
    class Client
      cattr_accessor :client

      FIREBASE_URL = "https://fcm.googleapis.com/fcm/send"
      FIREBASE_INSTANCE_ID_URL = "https://iid.googleapis.com/iid/v1"

      def default_headers
        return {
          "Authorization" => "key=#{JeraPush.firebase_api_key}",
          "Content-Type" => "application/json"
        }
      end

      def self.client
        if @@client.nil?
          @@client = JeraPush::Firebase::Client.new
        end
        @@client
      end

      def add_device_to_topic(device: , topic: , headers: {})
        url = "#{FIREBASE_INSTANCE_ID_URL}/#{device.token}/rel/topics/#{topic}"
        http = HTTPClient.new

        headers = {
          "Authorization" => "key=#{JeraPush.firebase_api_key}",
          "Content-Type" => "application/json"
        }

        http.post(url, Hash.new.to_json, headers)
      end
    end
  end
end
