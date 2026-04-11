require 'application_system_test_case'

class ContactPageTest < ApplicationSystemTestCase
  test 'the visitant can contact through the form' do
    visit new_contact_path

    within '#new_message' do
      fill_in 'message_identity', with: 'John Doe'
      fill_in 'message_email', with: 'jdoe@example.com'
      fill_in 'message_subject', with: 'Test Subject'
      fill_in 'message_content', with: 'Test Message'

      click_button I18n.t('links.execute')
    end

    assert_flash I18n.t('notices.sent_message')
  end

  test 'the visitant should see errors if the form is invalid' do
    visit new_contact_path

    within '#new_message' do
      click_button I18n.t('links.execute')
    end

    assert_flash I18n.t('alert.send_message_error')
    assert_text I18n.t('errors.messages.blank'), count: 4
  end
end
