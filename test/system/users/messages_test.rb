require 'application_system_test_case'

class Users::MessagesTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    @unread_messages = create_list(:message, 2)
    @read_message = create(:message, read: true)

    sign_in @user
  end

  test 'should display messages dashboard with filters' do
    visit users_messages_path

    assert_selector 'h1', text: I18n.t('users.messages.index.title').upcase
    assert_selector '#filters li', count: 3
    assert_selector '#messages li', count: 3
  end

  test 'should filter messages by read status' do
    visit users_messages_path

    click_on I18n.t('users.messages.index.filters.read')

    within '#messages' do
      assert_selector '.card', count: 1
      assert_text @read_message.subject
      assert_text @read_message.content
    end
  end

  test 'should open message details modal' do
    visit users_messages_path

    message = @unread_messages.first

    find("#open-modal-#{message.id}").click

    assert_selector "#modal_message_#{message.id}"

    within "#modal_message_#{message.id}" do
      assert_text message.subject
      assert_text message.content
    end
  end

  test 'should delete a message from modal' do
    visit users_messages_path

    message = @unread_messages.first

    find("#open-modal-#{message.id}").click

    assert_selector "#modal_message_#{message.id}"

    within "#modal_message_#{message.id}" do
      find('.btn-icon').click
    end

    assert_flash I18n.t('notices.destroy', resource: message.model_name.human)
    assert_no_selector "#message-#{message.id}"
  end

  test 'should toggle message read status' do
    visit users_messages_path

    message = @unread_messages.first

    find("#open-modal-#{message.id}").click

    within "#modal_message_#{message.id}" do
      find('.btn-icon-text').click
    end

    assert_flash I18n.t('notices.update', resource: message.model_name.human)
  end
end
