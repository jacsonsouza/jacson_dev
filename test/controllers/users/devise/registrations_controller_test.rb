require "test_helper"

class Users::Devise::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new registration page' do
    get new_user_registration_path

    assert_response :success
  end

  test 'should register user with valid credentials' do
    post_to user_registration_path, { email: 'user@jacson.dev.com',
                                      name: 'user',
                                      password: 'password',
                                      password_confirmation: 'password' }

    assert_redirected_to root_path
    assert_equal I18n.t('devise.registrations.signed_up_but_unconfirmed'), flash[:notice]
  end

  test 'should not register user with invalid email' do
    post_to user_registration_path, { email: 'userjacson.dev.com',
                                      name: 'user',
                                      password: 'password',
                                      password_confirmation: 'password' }

    assert_response :unprocessable_content
    assert_select 'p.text-red-500', I18n.t('errors.messages.invalid', attribute: 'E-mail')
  end

  test 'should not register user with invalid password' do
    post_to user_registration_path, { email: 'user@jacson.dev.com',
                                      name: 'user',
                                      password: 'pass',
                                      password_confirmation: 'pass' }

    assert_response :unprocessable_content
    assert_select 'p.text-red-500',
                  I18n.t('errors.messages.too_short',
                    attribute: User.human_attribute_name(:password), count: 6)
  end

  test 'should not register user with non matching password confirmation' do
    post_to user_registration_path, { email: 'user@jacson.dev.com',
                                      name: 'user',
                                      password: 'password',
                                      password_confirmation: 'pass' }

    assert_response :unprocessable_content
    assert_select 'p.text-red-500',
                  I18n.t('errors.messages.confirmation',
                    attribute: User.human_attribute_name(:password))
  end

  private

  def post_to(path, params = {})
    post path, params: { user: params }
  end
end
