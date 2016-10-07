module JeraPush
  class Admin::DevicesController < Admin::AdminController

    def index
      @filter = JeraPush::DeviceFilter.new params_filter
      @devices = @filter.search
    end

    def params_filter
      params.permit(:value, :field, :page, :per, platform: [])
    end

  end
end
