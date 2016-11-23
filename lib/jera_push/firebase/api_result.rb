module JeraPush
  module Firebase
    class ApiResult

      attr_accessor :result
      attr_accessor :registration_ids
      attr_accessor :topic

      def initialize(firebase_response, registration_ids: [], topic: nil)
        @result = firebase_response
        @registration_ids = registration_ids
      end

      def success?
        result && result.code == 200
      end

      def self.broadcast_result(message:, results:)
        return nil if results.blank? || message.blank?

        message.broadcast_result = []

        results.each do |result|
          obj = { platform: result.topic.split('_').last.titlecase }
          if result['error'].nil?
            message.status = :sent
          else
            message.status = :error
            obj[:message] = result['error']
          end
          obj[:firebase_id] = result['message_id']

          message.broadcast_result << obj
        end
        message.save
      end

      def topic_result(message:)
        return if message.nil? || result.nil?
        if !result['error'].nil?
          message.status = :error
          message.error_message = result['error']
        else
          message.status = :sent
        end
        message.firebase_id = result['message_id']
        message.save
      end

      def result_to(message:)
        return if result.nil? || result['results'].nil?
        message.status = :sent
        message.failure_count += result['failure'].to_i
        message.success_count += result['success'].to_i
        message.save

        result['results'].each_with_index do |result, index|
          token = registration_ids[index]
          device = message.message_devices.joins(:device).find_by(jera_push_devices: { token: token } )

          set_result(result, device) if token && device
        end
      end

      def set_result(result, device)
        if result['error'] && !result['error'].empty?
          device.status = :error
          device.error_message = result['error']
        else
          device.status = :success
        end
        device.firebase_id = result['message_id']
        device.save
      end

    end
  end
end
