require 'application_system_test_case'

class Users::ProjectCrudsTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)

    sign_in @user
  end

  test 'an admin user can see a list of projects' do
    projects = FactoryBot.create_list(:project, 2, user: @user)

    visit users_projects_path

    within 'ul#my-projects' do
      projects.each do |project|
        within "#project-#{project.id}" do
          assert_text project.name
          assert_text project.short_description
        end
      end
    end
  end

  test 'an admin user can see a project details' do
    project = FactoryBot.create(:project, user: @user)

    visit users_project_path(project)

    within '#project-header' do
      assert_text project.name
      assert_text project.short_description
    end

    assert_selector '.prose', text: project.details.to_plain_text
  end

  test 'an admin user can create a project' do
    skill = FactoryBot.create(:skill, user: @user)

    visit new_users_project_path

    within('form') do
      fill_in 'project[name]', with: 'Test Project'
      fill_in 'project[short_description]', with: 'A short description of the project'
      fill_date 'start_date', Date.new(2022, 1, 1)
      fill_date 'end_date', Date.new(2022, 2, 1)
      fill_in 'project[url]', with: 'https://example.com'
      fill_in 'project[repository]', with: 'https://github.com/test/test'
      find('trix-editor').set('Long description of the project')
      select Project.categories.keys.first.capitalize, from: 'Category'
      select skill.name, from: 'project[skill_ids][]'
      attach_file 'project[image]', 'test/fixtures/files/logo.png', make_visible: true
      click_on 'Create Project'
    end

    assert_flash I18n.t('notices.create', resource: Project.model_name.human)
  end

  test 'an admin user can update a project' do
    project = FactoryBot.create(:project, user: @user)

    visit edit_users_project_path(project)

    within('form') do
      fill_in 'project[name]', with: 'Updated Project'
      fill_in 'project[short_description]', with: 'A short and updated description'
      click_on 'Update Project'
    end

    assert_flash I18n.t('notices.update', resource: Project.model_name.human)
  end

  test 'an admin user can delete a project' do
    project = FactoryBot.create(:project, user: @user)

    visit users_projects_path

    within "#project-#{project.id}" do
      link = find('a[data-turbo-method="delete"]')
      accept_confirm { link.click }
    end

    assert_flash I18n.t('notices.destroy', resource: Project.model_name.human)
  end

  private

  def fill_date(attribute, date)
    select date.year, from: "project_#{attribute}_1i"
    select Date::MONTHNAMES[date.month], from: "project_#{attribute}_2i"
    select date.day, from: "project_#{attribute}_3i"
  end
end
