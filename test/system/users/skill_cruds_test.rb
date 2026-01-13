require 'application_system_test_case'

class Users::SkillCrudsTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)

    sign_in @user
  end

  test 'an admin user can see a list of skills' do
    skills = FactoryBot.create_list(:skill, 2, user: @user)

    visit users_skills_path

    within 'ul#my-skills' do
      skills.each do |skill|
        within "#skill-#{skill.id}" do
          assert_text skill.name
          assert_text skill.category_human
          assert_text skill.short_description
        end
      end
    end
  end

  test 'an admin user can see a skill details' do
    skill = FactoryBot.create(:skill, user: @user)

    visit users_skill_path(skill)

    within '#skill-header' do
      assert_text skill.name
      assert_text skill.short_description
    end

    assert_selector '.action-text', text: skill.description.to_plain_text
  end

  test 'an admin user can create a skill' do
    visit new_users_skill_path

    within('form') do
      fill_in 'skill[name]', with: 'Test Skill'
      fill_in 'skill[short_description]', with: 'Short description'
      fill_in 'skill[color]', with: '#FF0000'
      fill_in 'skill[proficiency]', with: 50
      attach_file 'skill[icon]', 'test/fixtures/files/skill_logo.png', make_visible: true
      find('trix-editor').set('Long description')
      fill_in 'skill[tag_list]', with: 'tag1, tag2'
      click_on 'Create Skill'
    end

    assert_flash I18n.t('notices.create', resource: Skill.model_name.human)
  end

  test 'an admin user can update a skill' do
    skill = FactoryBot.create(:skill, user: @user)

    visit edit_users_skill_path(skill)

    within('form') do
      fill_in 'skill[name]', with: 'Test Skill'
      fill_in 'skill[short_description]', with: 'Short description'
      fill_in 'skill[color]', with: '#FF0000'
      fill_in 'skill[proficiency]', with: 50
      find('trix-editor').set('Long description')
      fill_in 'skill[tag_list]', with: 'tag1, tag2'
      click_on 'Update Skill'
    end

    assert_flash I18n.t('notices.update', resource: Skill.model_name.human)
  end

  test 'cannot create a skill with invalid params' do
    visit new_users_skill_path

    within('form') do
      fill_in 'skill[name]', with: ''
      click_on 'Create Skill'
    end

    assert_input_error 'skill_name', I18n.t('errors.messages.blank')
  end

  test 'cannot update a skill with invalid params' do
    skill = FactoryBot.create(:skill, user: @user)

    visit edit_users_skill_path(skill)

    within('form') do
      fill_in 'skill[short_description]', with: ''
      click_on 'Update Skill'
    end

    assert_input_error 'skill_short_description', I18n.t('errors.messages.too_short', count: 10)
  end

  test 'an admin user can delete a skill' do
    skill = FactoryBot.create(:skill, user: @user)

    visit users_skills_path

    within "#skill-#{skill.id}" do
      link = find('a[data-turbo-method="delete"]')
      accept_confirm { link.click }
    end

    assert_flash I18n.t('notices.destroy', resource: Skill.model_name.human)
  end
end
