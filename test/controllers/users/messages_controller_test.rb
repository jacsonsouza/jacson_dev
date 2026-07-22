require 'test_helper'

class Users::MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in @user
  end

  test 'an authenticated user can view their messages' do
    get users_messages_path

    assert_response :success
  end

  test 'an unauthenticated user cannot view their messages' do
    sign_out @user
    get users_messages_path

    assert_response :redirect
  end

  test 'user should be able to mark a message as read' do
    message = create(:message)

    patch toggle_read_users_message_path(message)

    assert_response :redirect
    assert_notice I18n.t('notices.update', resource: message.model_name.human)
  end

  test 'user should be able to mark a message as unread' do
    message = create(:message, read: true)

    patch toggle_read_users_message_path(message)

    assert_response :redirect
    assert_notice I18n.t('notices.update', resource: message.model_name.human)
  end

  test 'user should be able to delete a message' do
    message = create(:message)

    assert_difference('Message.count', -1) do
      delete users_message_path(message)
    end

    assert_response :redirect
    assert_notice I18n.t('notices.destroy', resource: message.model_name.human)
  end

  private

  def assert_notice(message)
    assert_equal message, flash[:notice]
  end
end
