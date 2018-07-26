module JeraPush
  class Admin::DevicesController < Admin::AdminController

    def index
      @filter = JeraPush::DeviceFilter.new params_filter
      @devices = @filter.search.order(created_at: :desc).page(params[:page]).per(params[:per])

      respond_to do |format|
        format.js {}
        format.html
      end
    end

    def params_filter
      params.permit(:value, :field, :resource_name, platform: [])
    end

  end
end
