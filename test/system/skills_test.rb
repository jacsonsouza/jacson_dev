require 'application_system_test_case'

class SkillsTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
    @skills = FactoryBot.create_list(:skill, 2, user: @user, category: 'backend')
  end

  test 'a visitant user can see the skills page details' do
    visit skills_path

    within '#my-skills-page' do
      assert_selector '.heading-1', text: I18n.t('home.skills.title')
      assert_selector '.subtitle', text: I18n.t('home.skills.subtitle')
    end
  end

  test 'a visitant user can see the filters' do
    visit skills_path

    within '#skills-filter' do
      Skill.categories.each_key do |category|
        assert_selector "##{category}", text: I18n.t("links.#{category}")
      end
    end
  end

  test 'a visitant user can filter the skills' do
    mobile_skill = FactoryBot.create(:skill, user: @user, category: 'mobile')

    visit skills_path

    click_on I18n.t('links.mobile')

    within '#my-skills-list' do
      assert_selector 'li', count: 1
      assert_selector "#skill-#{mobile_skill.id}", text: mobile_skill.name
      assert_selector "#skill-#{mobile_skill.id}-category", text: I18n.t("links.#{mobile_skill.category}")
    end
  end

  test 'a visitant user can see all skills' do
    visit skills_path

    within '#my-skills-list' do
      @skills.each do |skill|
        within "#skill-#{skill.id}" do
          assert_text skill.name
          assert_text skill.category_human
          assert_text "#{skill.proficiency}%"
        end
      end
    end
  end
end
