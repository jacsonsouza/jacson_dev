require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @projects = create_list(:project, 3, user: @user)
  end

  test 'should render user projects' do
    get projects_path

    assert_response :success

    @projects.each do |project|
      assert_match project.name, response.body
      assert_match project.short_description, response.body
    end
  end
end
