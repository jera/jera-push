module JeraPush::Firebase
  class Client
    FIREBASE_API_VERSION = 'v1'
    FIREBASE_INSTANCE_ID_URL = "https://iid.googleapis.com/iid"
    SCOPE = 'https://www.googleapis.com/auth/firebase.messaging'.freeze
    
    def initialize
      @client = Google::Apis::FcmV1::FirebaseCloudMessagingService.new
      @authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(::JeraPush::credentials_path),
        scope: SCOPE
      )
      @client.authorization = fetch_access_token  
    end
      
    def send_to_device(message:)
      @client.send_message("projects/#{::JeraPush.project_name}", message, options: { retries: 3, multiplier: 1, max_interval: 2 })
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
      response = HTTParty.post(url, { body: body, headers: default_headers })
      JSON.parse(response)
    end

    def fetch_access_token
      @authorizer.fetch_access_token! if @authorizer.needs_access_token?
  
      @authorizer
    end  

    def default_headers
      {
        "Authorization" => "key=#{::JeraPush.firebase_api_key}",
        "Content-Type" => "application/json"
      }
    end
  end
end
