module JeraPush
  class Admin::MessagesController < Admin::AdminController

    def index
      @messages = JeraPush::Message.page(params[:page])
    end

    def show
      @message = JeraPush::Message.find_by id: params[:id]
    end

  end
end
