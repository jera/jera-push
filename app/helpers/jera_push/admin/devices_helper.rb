module JeraPush::Admin::DevicesHelper

  def resource_extras(device)
    if JeraPush.resource_attributes && JeraPush.resource_attributes.any?
      return resource_attributes(JeraPush.resource_attributes, device.try(:pushable))
    end
    return [device.try(:pushable)]
  end

  def resource_attributes(attributes, resource)
    return [] unless resource.present?

    attrs = attributes.collect do |attribute|
      if resource&.send(attribute)
        "#{I18n.t("activerecord.attributes.#{resource.class.to_s.downcase}.#{attribute}")}: #{resource.send(attribute)}"
      end
    end
    attrs.delete_if { |v| v.nil?}
  end

  def translate_resource_names(resources_name=[])
    resources_name.collect do |resource|
      ["#{I18n.t("activerecord.models.#{resource.downcase}.one")}", resource]
    end
  end

  def devices_fields_for_filter_select
    fields = []
    fields << [I18n.t("jera_push.admin.attributes.token"), "token"]

    if JeraPush.resource_attributes && JeraPush.resource_attributes.any?
      JeraPush.resource_attributes.each do |attribute|
        fields << ["#{I18n.t("jera_push.admin.attributes.#{attribute}")}", attribute]
      end
    end
    fields
  end

end
