module JeraPush
  class Admin::MessagesController < Admin::AdminController

    def index
      @messages = JeraPush::Message.all
    end

    def show
      @message = JeraPush::Message.find_by id: params[:id]
    end

  end
end
