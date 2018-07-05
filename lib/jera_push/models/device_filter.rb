module JeraPush
  class DeviceFilter
    include ActiveModel::Model

    attr_accessor :platform, :value, :field, :message_id, :resource_name

    def platform
      @platform ||= []
    end

    def search
      if resource_name
        @scope = JeraPush::Device.with_joins(resource_name)
      else
        @scope = JeraPush::Device.all
      end
      if message_id
        @scope = @scope.joins(:messages).where('jera_push_messages.id = ?', message_id)
      end
      if platform.any?
        @scope = @scope.where('jera_push_devices.platform in (?)', platform)
      end
      if field.present? && value.present?
        @scope = search_with_value_field(@scope)
      end
      @scope
    end

    private

    def search_with_value_field(scope)
      if field.to_sym == :token
        return scope.where('jera_push_devices.token like ?', "%#{value}%")
      elsif JeraPush.resource_attributes.include?(field.to_sym)
        return scope.where("#{resource_name.constantize.table_name}.#{field} like ?", "%#{value}%")
      end
      return scope
    end
  end
end
