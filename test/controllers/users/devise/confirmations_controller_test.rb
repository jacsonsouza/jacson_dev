require 'test_helper'

class Users::Devise::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user, confirmed_at: nil)
    # @confirmed_user = FactoryBot.create(:user, confirmed_at: Time.current)
  end

  test 'should display confirmation request form' do
    get new_user_confirmation_url

    assert_response :success
  end

  test 'should send confirmation instructions for unconfirmed user' do
    assert_emails 1 do
      post user_confirmation_url, params: { user: { email: @user.email } }
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.confirmations.send_instructions'), flash[:notice]
  end

  test 'should not send confirmation for already confirmed account' do
    @user.confirm

    assert_emails 0 do
      post user_confirmation_url, params: { user: { email: @user.email } }
    end

    assert_response :unprocessable_content
    assert_error_message I18n.t('errors.messages.already_confirmed')
  end

  test 'should handle non-existent email address gracefully' do
    assert_emails 0 do
      post user_confirmation_url, params: { user: { email: 'nonexistent@example.com' } }
    end

    assert_response :unprocessable_content
    assert_error_message I18n.t('errors.messages.not_found')
  end

  test 'should validate email parameter presence' do
    assert_emails 0 do
      post user_confirmation_url, params: { user: { email: '' } }
    end

    assert_response :unprocessable_content
    assert_error_message I18n.t('errors.messages.blank')
  end

  test 'should confirm user account with valid token' do
    token = @user.confirmation_token
    get user_confirmation_url(confirmation_token: token)

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.confirmations.confirmed'), flash[:notice]
    assert_predicate @user.reload, :confirmed?
  end
end
