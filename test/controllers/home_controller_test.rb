require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get home with success" do
    get root_path

    assert_response :success
  end

  test "should get about with success" do
    get about_path

    assert_response :success
  end

  test "should get contact with success" do
    get contact_path

    assert_response :success
  end

  test "should get skills with success" do
    get skills_path

    assert_response :success
  end

  test "should get portfolio with success" do
    get portfolio_path

    assert_response :success
  end
end
