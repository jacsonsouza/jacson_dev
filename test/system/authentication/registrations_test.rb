require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase
  test 'should display sign up form with name and email' do
    visit new_user_registration_path

    assert_selector 'h1', text: I18n.t('links.sign_up')

    within 'form' do
      assert_selector 'input[name="user[name]"]'
      assert_selector 'input[name="user[email]"]'
    end
  end

  test 'should display sign up form with password and password confirmation' do
    visit new_user_registration_path

    within 'form' do
      assert_selector 'input[name="user[password]"]'
      assert_selector 'input[name="user[password_confirmation]"]'
      assert_selector 'button', text: I18n.t('links.sign_up')
    end
  end

  test 'should display a flash message when sign up is successful' do
    visit new_user_registration_path

    within 'form' do
      fill_in 'user[name]', with: 'John Doe'
      fill_in 'user[email]', with: 'jdoe@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button I18n.t('links.sign_up')
    end

    assert_flash I18n.t('devise.registrations.signed_up_but_unconfirmed')
  end

  test 'should display errors when sign up is unsuccessful because of invalid data' do
    visit new_user_registration_path

    within 'form' do
      fill_in 'user[name]', with: ''
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''
      click_button I18n.t('links.sign_up')
    end

    ['Name', 'Email', 'Password'].each do |field|
      assert_selector ".user_#{field.downcase}", text: I18n.t('errors.messages.blank')
    end
  end
end
