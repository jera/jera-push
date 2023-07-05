module JeraPush::Services::Message
  class SendToTopicService < JeraPush::Services::BaseService
    def initialize(title:, body:, topic:)
      super
      @title = title
      @body = body
      @topic = topic
    end

    def call
      create_message
      send_topic
      update_message

      @message
    end

    private

    def create_message
      @message = JeraPush::Message.create(title: @title, body: @body, kind: :topic)
    end

    def send_topic
      @response = @firebase.send_message_to_topic(message: @message, topic: @topic)
    end

    def update_message
      @message.update(
        multicast_id: @response["multicast_id"],
        success_count: @response["success"],
        failure_count: @response["failure"]
      )
    end

  end
end
