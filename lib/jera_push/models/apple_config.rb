module JeraPush
  # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#ApnsConfig 
  class AppleConfig
    # Specify 5 to send the notification based on power considerations on the user’s device.
    # Specify 10 to send the notification immediately.
    attr_accessor :apns_priority
    attr_accessor :headers
    # REF: https://developer.apple.com/documentation/usernotifications/generating-a-remote-notification
    # REF: https://developer.apple.com/documentation/usernotifications/pushing-background-updates-to-your-app
    attr_accessor :content_available
    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#ApnsFcmOptions
    attr_accessor :analytics_label
    attr_accessor :analytics_image

    def initialize(
      apns_priority: '5',
      headers: {},
      content_available: 1,
      analytics_label: nil,
      analytics_image: nil
    )
      self.apns_priority = apns_priority
      self.headers = headers
      self.content_available = content_available
      self.analytics_label = analytics_label
    end

    def to_json
      apns_body
    end

    private

    def apns_body
      {
        headers: headers_body,
        payload: payload_body,
        fcm_options: fcm_body
      }
    end

    def headers_body
      headers.merge!({ 'apns-priority': apns_priority} )
    end

    def payload_body
      {
        aps: { 
          'content-available': content_available
        }
      }
    end

    def fcm_body
      {
        analytics_label: analytics_label,
        image: analytics_image
      }
    end
  end
end