class Users::MessagesController < Users::BaseController
  before_action :set_message, only: [:destroy, :toggle_read]

  def index
    @messages = Message.filter_by_read(params[:read]).order(created_at: :desc)
  end

  def destroy
    if @message.destroy
      redirect_to users_messages_path,
                  notice: t('notices.destroy', resource: @message.model_name.human)
    else
      redirect_to users_messages_path, alert: t('alert.delete_message_error')
    end
  end

  def toggle_read
    if @message.update(read: !@message.read)
      redirect_to users_messages_path,
                  notice: t('notices.update', resource: @message.model_name.human)
    else
      redirect_to users_messages_path, alert: t('alert.delete_message_error')
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end
end
