module JeraPush
  class V1::DevicesController < JeraPush::V1::VersionController

    def create
      @device = JeraPush::Device.find_by(token: params[:token], platform: params[:platform])
      if @device.nil?
        @device = JeraPush::Device.create device_params
      else
        @device.update_attributes(resource_id: params[:resource_id])
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
      params.permit(:token, :platform, :resource_id)
    end
  end
end
