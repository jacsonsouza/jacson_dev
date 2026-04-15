class ContactController < ApplicationController
  before_action :set_message

  def new; end

  def create
    @message.assign_attributes(message_params)

    if @message.save
      redirect_to new_contact_path, notice: t('notices.sent_message')
    else
      flash.now[:alert] = t('alert.send_message_error')
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_message
    @message = Message.new
  end

  def message_params
    params.expect(message: [:identity, :email, :subject, :content])
  end
end
