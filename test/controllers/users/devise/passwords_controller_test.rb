require 'test_helper'

class Users::Devise::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
  end

  test 'should get new' do
    get new_user_password_url

    assert_response :success
  end

  test 'should send reset password instructions for confirmed user' do
    assert_emails 1 do
      post user_password_url, params: { user: { email: @user.email } }
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.passwords.send_instructions'), flash[:notice]
  end

  test 'should send reset instructions even for unconfirmed user' do
    @user.update!(confirmed_at: nil)

    assert_emails 1 do
      post user_password_url, params: { user: { email: @user.email } }
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.passwords.send_instructions'), flash[:notice]
  end

  test 'should handle non-existent email address securely' do
    assert_emails 0 do
      post user_password_url, params: { user: { email: 'nonexistent@example.com' } }
    end

    assert_response :unprocessable_content
    assert_error_message I18n.t('errors.messages.not_found')
  end

  test 'should validate email parameter presence' do
    assert_emails 0 do
      post user_password_url, params: { user: { email: '' } }
    end

    assert_response :unprocessable_content
    assert_error_message I18n.t('errors.messages.blank')
  end

  test 'should successfully reset password with valid token' do
    raw_token = @user.send_reset_password_instructions

    patch user_password_url,
          params: {
            user: {
              reset_password_token: raw_token,
              password: 'new_secure_password123',
              password_confirmation: 'new_secure_password123'
            }
          }

    assert_redirected_to root_path
    assert_equal I18n.t('devise.passwords.updated'), flash[:notice]
    assert @user.reload.valid_password?('new_secure_password123')
  end

  test 'should validate new password meets requirements' do
    raw_token = @user.send_reset_password_instructions

    patch user_password_url,
          params: {
            user: {
              reset_password_token: raw_token,
              password: '123',
              password_confirmation: '123'
            }
          }

    assert_response :unprocessable_content
    assert_error_message I18n.t('errors.messages.too_short', count: 6)
  end
end
