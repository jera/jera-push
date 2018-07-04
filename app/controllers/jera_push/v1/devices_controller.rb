module JeraPush
  class V1::DevicesController < JeraPush::V1::VersionController

    def create
      @device = JeraPush::Device.find_by(token: device_params[:token], platform: device_params[:platform])
      device_params[:resource_type] ||= JeraPush.resource_name
      if @device.nil?
        @device = JeraPush::Device.create(token: device_params[:token], platform: device_params[:platform], pushable_id: device_params[:resource_id], pushable_type: device_params[:resource_type].upcase)
      else
        @device.update_attributes(pushable_id: device_params[:resource_id], pushable_type: device_params[:resource_type].upcase)
      end
      render_object(@device)
    end

    def destroy
      @device = JeraPush::Device.find_by(token: params[:token], platform: params[:platform])
      return render_not_found if @device.nil?
      @device.destroy
      render_object(@device)
    end

    private
    def device_params
      params.permit(:token, :platform, :resource_id, :resource_type)
    end
  end
end
