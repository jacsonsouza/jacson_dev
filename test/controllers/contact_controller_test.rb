require 'test_helper'

class ContactControllerTest < ActionDispatch::IntegrationTest
  test 'should successfully get contact page' do
    get new_contact_path

    assert_response :success
  end

  test 'should successfully submit contact form' do
    assert_difference 'Message.count', 1 do
      post contact_index_path, params: {
        message: {
          identity: 'John Doe',
          email: 'jdoe@gmail.com',
          subject: 'Test Subject',
          content: 'Test Content'
        }
      }
    end

    assert_response :redirect
    assert_equal I18n.t('notices.sent_message'), flash[:notice]
  end

  test 'should fail to submit contact form with invalid data' do
    assert_no_difference 'Message.count' do
      post contact_index_path, params: {
        message: {
          identity: '',
          email: 'invalid_email',
          subject: '',
          content: ''
        }
      }
    end

    assert_response :unprocessable_content
    assert_equal I18n.t('alert.send_message_error'), flash[:alert]
  end
end
