require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
  end

  test 'should successfully get index' do
    get root_path

    assert assigns(:user)
    assert_response :success
  end
end
