require "test_helper"

class Users::Devise::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
  end

  test "should get new" do
    get new_user_confirmation_url
    assert_response :success
  end

  test 'should send email' do
    post user_confirmation_url, params: { user: { email: @user.email } }
    assert_response :redirect
  end

  test 'should not send email if already confirmed' do
    @user.update(confirmed_at: Time.now)

    post user_confirmation_url, params: { user: { email: @user.email } }
    assert_response :unprocessable_content
  end

  test 'should not send email if no email' do
    post user_confirmation_url, params: { user: { email: 'n/a' } }
    assert_response :unprocessable_content
  end
end
