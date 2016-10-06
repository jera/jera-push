module JeraPush
  class Admin::DevicesController < Admin::AdminController

    def index
      @devices = JeraPush::Device.page(params[:page])
    end

  end
end
