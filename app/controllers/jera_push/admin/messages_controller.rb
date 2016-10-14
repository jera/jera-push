module JeraPush
  class Admin::MessagesController < Admin::AdminController

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
      apply_filter
    end

    def device_filter
      apply_filter
      respond_to :js
    end

    def message_devices_filter
      apply_filter
      respond_to :js
    end

    def create
      return render_invalid_params if params[:message].blank? || params[:type].blank?

      client = JeraPush::Firebase::Client.instance
      message_content = JeraPush::Message.format_hash params[:message]

      case params[:type].to_sym
      when :broadcast
        devices = JeraPush::Device.all
      when :specific
        return render_invalid_params if params[:devices].blank?
        devices = JeraPush::Device.where(id: params[:devices].uniq.map(&:to_i))
      end

      JeraPush::Message.send_to(devices, content: message_content)

      respond_to :js
    end

    private

      def apply_filter
        @filter = JeraPush::DeviceFilter.new device_filter_params
        @devices = @filter.search.limit(params[:limit]).order(created_at: :desc)
        @message_devices = JeraPush::MessageDevice.includes(:resource, :device).where('message_id = :id and device_id in (:device_ids)', id: params[:id], device_ids: @devices.pluck(:id))
      end

      def device_filter_params
        params.permit(:value, :field, platform: []).merge({ message_id: params[:id] })
      end

  end
end
