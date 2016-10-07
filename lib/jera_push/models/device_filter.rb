module JeraPush
  class DeviceFilter
    include ActiveModel::Model

    attr_accessor :platform, :value, :field, :page, :per, :message_id

    def platform
      @platform ||= []
    end

    def search
      @scope = JeraPush::Device.joins(:resource).includes(:resource)
      if message_id
        @scope = @scope.joins(:messages).where('jera_push_messages.id = ?', message_id)
      end
      if platform.any?
        @scope = @scope.where('jera_push_devices.platform in (?)', platform)
      end
      if field.present? && value.present?
        @scope = search_with_value_field(@scope)
      end
      @scope.order(created_at: :desc).page(page).per(per)
    end

    private

    def search_with_value_field(scope)
      if field.to_sym == :token
        return scope.where('jera_push_devices.token like ?', "%#{value}%")
      elsif JeraPush.resource_attributes.include?(field.to_sym)
        return scope.where("#{JeraPush.resource_name.constantize.table_name}.#{field} like ?", "%#{value}%")
      end
      return scope
    end
  end
end
