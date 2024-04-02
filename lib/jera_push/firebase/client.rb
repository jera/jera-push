module JeraPush::Firebase
  class Client
    cattr_accessor :client
    # TODO: Update to FCM V1 API -> https://firebase.google.com/docs/cloud-messaging/migrate-v1?hl=pt-br
    # FIREBASE_URL = "https://fcm.googleapis.com/fcm/send"
    FIREBASE_API_VERSION = 'v1'
    FIREBASE_URL = "https://fcm.googleapis.com/#{FIREBASE_API_VERSION}/projects/#{::JeraPush.project_name}/messages:send"
    FIREBASE_INSTANCE_ID_URL = "https://iid.googleapis.com/iid"
    
    @instance = new

    private_class_method :new

    def self.instance
      @instance
    end

    def send_to_devices(message:)
      send(url: FIREBASE_URL, body: message)
    end

    def add_device_to_topic(topic:, device:)
      send(url: "#{FIREBASE_INSTANCE_ID_URL}/v1/#{device.token}/rel/topics/#{topic}")
    end

    def remove_device_from_topic(topic:, devices: [])
      send(
        url: "#{FIREBASE_INSTANCE_ID_URL}/v1:batchRemove",
        body: {
          to: "/topics/#{topic}",
          registration_tokens: devices.pluck(:token)
        }.to_json
      )
    end

    def send_message_to_topic(message:, topic:)
      send(
        url: FIREBASE_URL,
        body: {
          title: message.title,
          body: message.body,
          to: "/topics/#{topic}",
          priority: 'high'
        }.to_json
      )
    end

    private

    def send(url:, body: {})
      JSON.parse(HTTParty.post(url, { body: body, headers: default_headers }))
    end

    def default_headers
      {
        "Authorization" => "Bearer #{::JeraPush.firebase_api_key}",
        "Content-Type" => "application/json"
      }
    end

  end
end
