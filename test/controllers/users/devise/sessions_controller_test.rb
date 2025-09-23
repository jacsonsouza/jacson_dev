require "test_helper"

class Users::Devise::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
  end

  test "should get new" do
    get new_user_session_path
    assert_response :success
  end

  test 'should sign in with a valid user' do
    post user_session_path, params: { user: { email: @user.email, password: @user.password } }

    assert_redirected_to users_root_path
  end
end
