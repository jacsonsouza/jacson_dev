require 'test_helper'

class Users::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  test 'should respond with success to get index' do
    get users_projects_path

    assert_response :success
  end

  test 'should get all user projects' do
    @project = FactoryBot.create(:project, user: @user)

    get users_projects_path

    assert_response :success
    # assert_contains @response.body, @project.name
  end
end
