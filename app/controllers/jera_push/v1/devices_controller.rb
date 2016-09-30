module JeraPush
  class V1::DevicesController < JeraPush::V1::VersionController

    def create
      @device = JeraPush::Device.find_or_create_by device_params
      render_object(@device)
    end

    def destroy
      @device = JeraPush::Device.find_by device_params
      return render_not_found if @device.nil?
      @device.destroy
      render_object(@device)
    end

    private
    def device_params
      { token: params[:token], platform: params[:platform] }
    end
  end
end
