require "test_helper"

class Users::Devise::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
  end

  test "should get new" do
    get new_user_password_url
    assert_response :success
  end

  test 'should send reset password instructions' do
    post user_password_url, params: { user: { email: @user.email } }

    assert_response :redirect
    assert_equal I18n.t("devise.passwords.send_instructions"), flash[:notice]
  end

  test "should get edit" do
    token = @user.send_reset_password_instructions

    get edit_user_password_url(reset_password_token: token)
    assert_response :success
  end

  test "should update password" do
    token = @user.send_reset_password_instructions

    patch user_password_url, 
          params: { user: { email: @user.email, 
                            reset_password_token: token, 
                            password: "password", 
                            password_confirmation: "password" } }

    assert_response :redirect
    assert_equal I18n.t("devise.passwords.updated_not_active"), flash[:notice]
  end
end
