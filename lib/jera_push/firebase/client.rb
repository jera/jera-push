module JeraPush
  module Firebase
    class Client

      cattr_accessor :client

      FIREBASE_URL = "https://fcm.googleapis.com/fcm/send"
      FIREBASE_INSTANCE_ID_URL = "https://iid.googleapis.com/iid"

      def default_headers
        return {
          "Authorization" => "key=#{::JeraPush.firebase_api_key}",
          "Content-Type" => "application/json"
        }
      end

      def self.instance
        @@client ||= JeraPush::Firebase::Client.new
      end

      def send_message(message:, devices: [])
        registration_ids = devices.map(&:token)
        body = { registration_ids: registration_ids, priority: 'high' }
        response = HTTParty.post(FIREBASE_URL, { body: body.merge!(message).to_json, headers: default_headers })
        puts response
        ApiResult.new(response, registration_ids: registration_ids)
      end

      def send_message_to_topic(message:, topic:)
        body = { to: "/topics/#{topic}", priority: 'high' }
        response = HTTParty.post(FIREBASE_URL, { body: body.merge!(message).to_json, headers: default_headers })
        puts response
        ApiResult.new(response, topic: topic)
      end

      def device_details(device:)
        url = "#{FIREBASE_INSTANCE_ID_URL}/info/#{device.token}/"
        response = HTTParty.post(url, { body: Hash.new.to_json, headers: default_headers })
        ApiResult.new(response)
      end

      def add_device_to_topic(topic:, device:)
        url = "#{FIREBASE_INSTANCE_ID_URL}/v1/#{device.token}/rel/topics/#{topic}"
        response = HTTParty.post(url, { body: Hash.new.to_json, headers: default_headers })
        ApiResult.new(response)
      end

      def add_devices_to_topic(topic:, devices: [])
        url = "#{FIREBASE_INSTANCE_ID_URL}/v1:batchAdd"
        body = {
          "to": "/topics/#{topic}",
          "registration_tokens": devices.map(&:token),
        }
        response = HTTParty.post(url, { body: body.to_json, headers: default_headers })
        ApiResult.new(response)
      end

      def remove_device_from_topic(topic:, devices: [])
        url = "#{FIREBASE_INSTANCE_ID_URL}/v1:batchRemove"
        body = {
          "to": "/topics/#{topic}",
          "registration_tokens": devices.map(&:token),
        }
        response = HTTParty.post(url, { body: body.to_json, headers: default_headers })
        ApiResult.new(response)
      end
    end
  end
end
