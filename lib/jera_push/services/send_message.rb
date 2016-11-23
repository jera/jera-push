module JeraPush
  module Service
    class SendMessage

      def initialize(*args)
        args[0].map { |attr_name, value| instance_variable_set("@#{attr_name}", value) }
      end

      def call
        return false unless valid?

        message_content = JeraPush::Message.format_hash @message

        case @type.to_sym
        when :broadcast
          JeraPush::Message.send_broadcast(content: message_content)
        when :specific
          target_devices = JeraPush::Device.where(id: @devices.uniq.map(&:to_i))
          JeraPush::Message.send_to(target_devices, content: message_content)
        end
      end

      def valid?
        valid = @message.present? && @type.present?
        @type.to_sym == :broadcast ? valid : valid && @devices.present?
      end

    end
  end
end
