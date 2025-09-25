require 'application_system_test_case'

class UnlocksTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
    @user.lock_access!
  end

  test 'should send unlock instructions when solicited by user' do
    visit new_user_unlock_path

    assert_selector 'h1', text: I18n.t('links.send_unlock_instructions')

    within 'form' do
      fill_in 'user_email', with: @user.email
      click_on I18n.t('links.send_unlock_instructions')
    end

    assert_flash I18n.t('devise.unlocks.send_instructions')
  end
end
