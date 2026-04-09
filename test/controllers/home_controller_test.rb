require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @projects = FactoryBot.create_list(:project, 3, user: @user)
  end

  test 'should get index successfully' do
    get root_path

    assert_response :success
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
