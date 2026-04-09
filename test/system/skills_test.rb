require 'application_system_test_case'

class SkillsTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
    @skills = FactoryBot.create_list(:skill, 2, user: @user, category: 'backend')
  end

  test 'a visitant user can see the skills page details' do
    visit skills_path

    within '#skills-header' do
      assert_selector 'h1', text: I18n.t('home.skills.title')
      assert_selector 'p', text: I18n.t('home.skills.subtitle').upcase
    end
  end

  test 'a visitant user can see the filters' do
    visit skills_path

    within '#skills-filter' do
      Skill.categories.each_key do |category|
        assert_selector "##{category}", text: I18n.t("links.#{category}").upcase
      end
    end
  end

  test 'a visitant user can filter the skills' do
    mobile_skill = FactoryBot.create(:skill, user: @user, category: 'mobile')

    visit skills_path

    within '#skills-filter' do
      find_by_id('mobile').click
    end

    within '#skills' do
      assert_selector 'li', count: 1
      assert_selector "#skill-#{mobile_skill.id}", text: mobile_skill.name
      assert_text mobile_skill.category_human.upcase
    end
  end

  test 'a visitant user can see all skills' do
    visit skills_path

    within '#skills' do
      @skills.each do |skill|
        within "#skill-#{skill.id}" do
          assert_text skill.name
          assert_text skill.category_human.upcase
          assert_text "#{skill.proficiency}%"
        end
      end
    end
  end
end
