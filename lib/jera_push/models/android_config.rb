module JeraPush
  class AndroidConfig
    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#AndroidMessagePriority
    attr_accessor :priority
    attr_accessor :analytics_label


    def initialize(
      priority: 'high',
      analytics_label: nil
    )
      self.priority = priority
      self.analytics_label = analytics_label
    end

    def to_json
      android_body
    end

    private

    # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#AndroidConfig
    def android_body
      {
        priority: priority,
        # REF: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#FcmOptions
        fcm_options: {
          analytics_label: analytics_label
        }
      }
    end
  end
end
