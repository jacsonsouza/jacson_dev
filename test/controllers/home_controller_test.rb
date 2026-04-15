require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test 'should get index successfully' do
    get root_path

    assert_response :success
  end

  test 'should get the user first name on the index page' do
    get root_path

    assert_response :success
    assert_match @user.first_name, response.body
  end

  test 'should successfully access about page' do
    get about_path

    assert_response :success
  end
end
