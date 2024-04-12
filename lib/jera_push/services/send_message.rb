module JeraPush
  module Services
    class SendMessage

      def initialize(*args)
        @type = args.first[:type].to_sym
        @message = args.first[:message]
        @devices = args.first[:devices]
      end

      def call
        return false unless valid?

        message_content = format_hash(@message)
        case @type
        when :broadcast
          # Topicos não estão funcionando.
          # JeraPush::Message.send_broadcast(content: message_content)
        when :specific
          target_devices = JeraPush::Device.where(id: @devices.uniq.map(&:to_i))
          result = JeraPush::Services::SendToDevicesService.new(devices: target_devices, 
            title: message_content[:title], 
            body: message_content[:body], 
            data: message_content
          ).call
          result
        end
      end

      def valid?
        valid = @message.present? && @type.present?
        @type.to_sym == :broadcast ? valid : valid && @devices.present?
      end

      def format_hash(messages = [])
        return false if messages.blank?
        messages.collect do |obj|
          hash = { obj[:key].to_sym => obj[:value] }
          hash.delete_if { |key, value| key.blank? || value.blank? }
        end.reduce(:merge)
      end

    end
  end
end