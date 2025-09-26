require 'application_system_test_case'

class HomesTest < ApplicationSystemTestCase
  test 'visiting the home page' do
    visit root_path

    within '#home' do
      assert_selector 'h1', text: "#{I18n.t('home.index.greeting')}Jacson"
      assert_selector 'h2', text: I18n.t('home.index.occupation')
      assert_selector 'p', text: I18n.t('home.index.introduction')
    end
  end

  test 'seeing the side menu links' do
    visit root_path

    find_by_id('side-menu').hover

    within '#side-menu' do
      assert_selector 'li', count: 5
    end
  end
end
