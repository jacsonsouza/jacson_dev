require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get home with success' do
    get root_path

    assert_response :success
  end
end
