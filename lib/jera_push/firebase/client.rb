module JeraPush::Firebase
  class Client
    FIREBASE_API_VERSION = 'v1'.freeze
    FIREBASE_INSTANCE_ID_URL = 'https://iid.googleapis.com/iid'.freeze
    SCOPE = 'https://www.googleapis.com/auth/firebase.messaging'.freeze

    def initialize
      @client = Google::Apis::FcmV1::FirebaseCloudMessagingService.new
      @authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(::JeraPush::credentials_path),
        scope: SCOPE
      )
      @client.authorization = fetch_access_token
    end

    def send_to_device(push:)
      @client.send_message("projects/#{::JeraPush.project_id}", push.to_json, options: { retries: 3, multiplier: 1, max_interval: 2 })
    end

    private

    def fetch_access_token
      @authorizer.fetch_access_token! if @authorizer.needs_access_token?

      @authorizer
    end
  end
end
