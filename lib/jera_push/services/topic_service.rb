module JeraPush::Services
  class TopicService < JeraPush::Services::BaseService
    DEFAULT_TOPIC = 'general'

    def initialize(*)
      super
    end

    def subscribe(device:, topic: DEFAULT_TOPIC)
      @firebase.add_device_to_topic(device: device, topic: topic)
    end

    def unsubscribe(device, topic = DEFAULT_TOPIC)
      @firebase.remove_device_from_topic(devices: [device], topic: topic)
    end

  end
end