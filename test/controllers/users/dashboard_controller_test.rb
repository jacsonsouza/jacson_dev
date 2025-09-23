require "test_helper"

class Users::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  test "should get index" do
    get users_root_path
    assert_response :success
  end
end
