require "test_helper"

class Users::Devise::UnlocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @user.lock_access!
  end

  test "should get new" do
    get new_user_unlock_path
    assert_response :success
  end

  test "should send unlock instructions" do
    post user_unlock_path, params: { user: { email: @user.email } }

    assert_response :redirect
    assert_equal I18n.t("devise.unlocks.send_instructions"), flash[:notice]
  end
end
