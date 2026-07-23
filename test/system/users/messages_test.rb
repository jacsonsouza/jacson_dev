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

    find("#open-modal-#{@unread_messages.first.id}", visible: false).click

    assert_selector "#modal_message_#{@unread_messages.first.id}"

    within "#modal_message_#{@unread_messages.first.id}" do
      assert_text @unread_messages.first.subject
      assert_text @unread_messages.first.content
    end
  end

  test 'should delete a message from modal' do
    visit users_messages_path

    find("#open-modal-#{@unread_messages.first.id}", visible: false).click

    assert_selector "#modal_message_#{@unread_messages.first.id}"

    within "#modal_message_#{@unread_messages.first.id}" do
      find('.btn-icon').click
    end

    assert_flash I18n.t('notices.destroy', resource: @unread_messages.first.model_name.human)
    assert_no_selector "#message-#{@unread_messages.first.id}"
  end

  test 'should toggle message read status' do
    visit users_messages_path

    find("#open-modal-#{@unread_messages.first.id}", visible: false).click

    assert_selector "#modal_message_#{@unread_messages.first.id}"

    within "#modal_message_#{@unread_messages.first.id}" do
      find('.btn-icon-text').click
    end

    assert_flash I18n.t('notices.update', resource: @unread_messages.first.model_name.human)
  end
end
