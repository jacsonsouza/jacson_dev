require 'test_helper'

class Users::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, user: @user)

    sign_in @user
  end

  test 'should allow access when signed in' do
    assert_access_to [
      users_projects_path,
      new_users_project_path,
      edit_users_project_path(@project)
    ]
  end

  test 'should create a new project for the user' do
    new_project = FactoryBot.build(:project, user: @user)

    assert_difference('Project.count') do
      post users_projects_path,
           params: { project: { name: new_project.name,
                                category: new_project.category,
                                short_description: new_project.short_description,
                                details: new_project.details,
                                image: fixture_file_upload('test/fixtures/files/logo.png', 'image/png'),
                                url: new_project.url,
                                start_date: new_project.start_date,
                                end_date: new_project.end_date } }

      assert_response :redirect
      assert_notice I18n.t('notices.create', resource: new_project.model_name.human)
    end
  end

  test 'should edit a project for the user' do
    patch users_project_path(@project),
          params: { project: { name: 'New name' } }

    assert_response :redirect
    assert_notice I18n.t('notices.update', resource: @project.model_name.human)
  end

  test 'should destroy a project for the user' do
    assert_difference('Project.count', -1) do
      delete users_project_path(@project)
    end

    assert_response :redirect
    assert_notice I18n.t('notices.destroy', resource: @project.model_name.human)
  end

  test 'should not create a new project with invalid data' do
    assert_no_difference('Project.count') do
      post users_projects_path,
           params: { project: { name: '' } }
    end

    assert_response :unprocessable_content
  end

  test 'should not update a project with invalid data' do
    patch users_project_path(@project),
          params: { project: { name: '' } }

    assert_response :unprocessable_content
  end

  private

  def assert_notice(message)
    assert_equal message, flash[:notice]
  end
end
