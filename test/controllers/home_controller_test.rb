require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
  end

  test 'should get index successfully' do
    get root_path

    assert_response :success
  end

  test 'should render user projects' do
    projects = FactoryBot.create_list(:project, 3, user: @user)

    get projects_path

    assert_response :success

    projects.each do |project|
      assert_match project.name, response.body
      assert_match project.short_description, response.body
    end
  end

  test 'should render user skills' do
    skills = FactoryBot.create_list(:skill, 2, user: @user)

    get skills_path

    assert_response :success

    skills.each do |skill|
      assert_match skill.name, response.body
    end
  end

  test 'should successfully access about page' do
    get about_path

    assert_response :success
  end
end
