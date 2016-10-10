module JeraPush
  class Admin::DevicesController < Admin::AdminController

    def index
      @filter = JeraPush::DeviceFilter.new params_filter
      @devices = @filter.search

      respond_to do |format|
        format.js {}
        format.html
      end
    end

    def params_filter
      params.permit(:value, :field, :page, :per, platform: [])
    end

  end
end
