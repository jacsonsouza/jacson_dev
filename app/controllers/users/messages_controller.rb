class Users::MessagesController < Users::BaseController
  def index
    @messages = Message.order(created_at: :desc)
  end

  def destroy
    message = Message.find(params[:id])

    if message.destroy
      redirect_to users_messages_path,
                  notice: t('notices.destroy', resource: message.model_name.human)
    else
      redirect_to users_messages_path, alert: t('alert.delete_message_error')
    end
  end

  def toggle_read
    message = Message.find(params[:id])

    if message.update(read: !message.read)
      redirect_to users_messages_path,
                  notice: t('notices.update', resource: message.model_name.human)
    else
      redirect_to users_messages_path, alert: t('alert.delete_message_error')
    end
  end
end
