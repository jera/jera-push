module JeraPush::Services
  class SendToEveryoneService < JeraPush::Services::BaseService
    def initialize(title:, body:)
      super
      @title = title
      @body = body
    end

    def call
      create_message
      send_android
      send_ios
      update_message

      @message
    end

    private

    def create_message
      @message = JeraPush::Message.create(title: @title, body: @body, kind: :everyone)
    end

    def send_android
      @response_android = @firebase.send_message_to_topic(message: @message, topic: JeraPush.send('topic_android'))
    end

    def send_ios
      @response_ios = @firebase.send_message_to_topic(message: @message, topic: JeraPush.send('topic_ios'))
    end

    def update_message
      @message.update(
        success_count: @response_android["success"] + @response_ios["success"],
        failure_count: @response_android["failure"] + @response_ios["failure"]
      )
    end

  end
end
