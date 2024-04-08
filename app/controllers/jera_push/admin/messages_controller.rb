module JeraPush
  class Admin::MessagesController < Admin::AdminController

    def index
      @messages = JeraPush::MessagePresenter.wrap(JeraPush::Message.all.order(id: :desc))
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
      push_message = JeraPush::Services::SendMessage.new(params).call

      if push_message
        flash[:notice] = t('jera_push.admin.messages.new.toast.success')
        redirect_to jera_push_admin_message_path(push_message)
      else
        flash[:error] = t('jera_push.admin.messages.new.toast.error')
        apply_filter
        render :new
      end
    end

    def resend_push
      message = JeraPush::Message.find(params[:id])
      message.devices.find_each do |device|
        JeraPush::Services::SendPushService.new(device: device, 
          message: message,
          message_device: message.message_devices.where(device: device).last
        ).call
      end
      flash[:notice] = t('jera_push.admin.messages.new.toast.success')
      redirect_to jera_push_admin_message_path(message)
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
