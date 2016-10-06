module JeraPush::Admin::DevicesHelper

  def resource_extras(device)
    if JeraPush.resource_attributes && JeraPush.resource_attributes.any?
      return resource_attributes(JeraPush.resource_attributes, device.resource)
    end
    return [device.resource]
  end

  def resource_attributes(attributes, resource)
    if resource
      attrs = attributes.collect do |attribute|
        "#{attribute}: #{resource.send(attribute)}"
      end
      return attrs.delete_if { |v| v.nil?}
    end
  end

  def devices_fields_for_filter_select
    fields = [:token]
    if JeraPush.resource_attributes && JeraPush.resource_attributes.any?
      JeraPush.resource_attributes.each do |attribute|
        fields << attribute
      end
    end
    fields
  end

end
