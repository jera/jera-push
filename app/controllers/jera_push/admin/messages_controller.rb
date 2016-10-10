module JeraPush
  class Admin::MessagesController < Admin::AdminController
    respond_to :js

    def index
      @messages = JeraPush::MessagePresenter.wrap(JeraPush::Message.all)
      @messages = Kaminari.paginate_array(@messages).page(params[:page])
    end

    def show
      @message = JeraPush::Message.find_by id: params[:id]
      @message = JeraPush::MessagePresenter.new @message
      apply_filter
    end

    def new
      @message = JeraPush::Message.new
    end

    def device_filter
      apply_filter
      respond_to :js
    end

    private

      def apply_filter
        @filter = JeraPush::DeviceFilter.new device_filter_params
        @devices = @filter.search
      end

      def device_filter_params
        params.permit(:value, :field, :page, :per, platform: []).merge({ message_id: params[:id] })
      end

  end
end
