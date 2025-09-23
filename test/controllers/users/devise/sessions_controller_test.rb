require "test_helper"

class Users::Devise::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
  end

  test "should get new" do
    get new_user_session_path
    assert_response :success
  end

  test "should sign in with valid credentials" do
    post user_session_path, params: login_params(@user.email, @user.password)

    assert_redirected_to users_root_path
    assert_equal I18n.t("devise.sessions.signed_in"), flash[:notice]
  end

  test "should reject authentication with unregistered email" do
    post user_session_path,
         params: login_params("unregistered@example.com", "password")

    assert_response :unprocessable_content
    assert_equal I18n.t("devise.failure.invalid", authentication_keys: "Email"), flash[:alert]
  end

  test "should reject authentication with invalid password" do
    post user_session_path, params: login_params(@user.email, "invalid")

    assert_response :unprocessable_content
    assert_equal I18n.t("devise.failure.invalid", authentication_keys: "Email"), flash[:alert]
  end

  test "should sign out successfully" do
    sign_in @user
    delete destroy_user_session_path

    assert_redirected_to new_user_session_path
    assert_equal I18n.t("devise.sessions.signed_out"), flash[:notice]
  end

  private

  def login_params(email, password)
    { user: { email: email, password: password } }
  end
end
