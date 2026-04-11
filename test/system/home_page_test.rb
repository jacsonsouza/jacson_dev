require 'application_system_test_case'

class HomePageTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test 'should displays the home page with user infos' do
    visit root_path

    within '#home' do
      assert_selector 'h1', text: @user.first_name
      assert_selector 'p', text: I18n.t('home.index.subtitle')
    end
  end
end
