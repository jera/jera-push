module JeraPush
  class Push
    attr_accessor :device
    attr_accessor :devices
    attr_accessor :notification
    attr_accessor :data
    attr_accessor :android
    attr_accessor :ios
    attr_accessor :analytics_label
    attr_accessor :validate_only

    def initialize(
      data: {},
      device: nil,
      devices: [],
      validate_only: false,
      analytics_label: '',
      ios_config: AppleConfig.new,
      title: '',
      body: '',
      image: '',
      notification: nil,
      android_config: AndroidConfig.new
    )
      self.data = data
      self.device = device
      self.devices = devices
      self.validate_only = validate_only
      self.analytics_label = analytics_label
      self.ios = ios_config
      self.notification = notification.nil? ? Notification.new(title: title, body: body, image: image) : notification
      self.android = android_config
    end

    def to_json
      base_body
    end

    private

    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#resource:-message
    def base_body
      {
        message: build_message_body,
        validate_only: validate_only
      }
    end

    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#resource:-message
    def build_message_body
      {
        token: device.token,
        notification: notification_body,
        data: data_body,
        apns: apns_body,
        android: android_body,
        fcm_options: fcm_body
      }
    end

    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#Notification
    def notification_body
      notification.to_json
    end

    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#resource:-message
    def data_body
      data.merge(notification.to_json)
    end

    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#ApnsConfig
    def apns_body
      ios.analytics_label = analytics_label
      ios.to_json
    end

    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#AndroidConfig
    def android_body
      android.analytics_label = analytics_label
      android.to_json
    end

    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#FcmOptions
    def fcm_body
      {
        analytics_label: analytics_label
      }
    end
  end
end
