require 'application_system_test_case'

class ProjectsTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
    @projects = FactoryBot.create_list(:project, 3, user: @user)
  end

  test 'a visitant user can see all portfolio projects' do
    visit projects_path

    within '#projects' do
      @projects.each do |project|
        within "#project-#{project.id}" do
          assert_text project.name
          assert_text project.short_description
        end
      end
    end
  end

  test 'a visitant user can filter the skills' do
    project_mobile = FactoryBot.create(:project, user: @user, category: 'mobile')

    visit projects_path

    click_on I18n.t('links.mobile')

    assert_selector "#project-#{project_mobile.id}", text: project_mobile.name
  end

  test 'a visitant user can see the project details' do
    project = @projects.first

    visit project_path(project)

    within '#project-header' do
      assert_text project.name
      assert_text project.short_description
    end

    assert_selector '.prose', text: project.details.to_plain_text
  end
end
