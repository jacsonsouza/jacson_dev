class Users::MessagesController < Users::BaseController
  def index
    @messages = Message.order(created_at: :desc)
  end
end
