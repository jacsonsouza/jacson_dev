require 'test_helper'

class Users::Devise::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'should not allow sign up' do
    get new_user_registration_path

    assert_response :redirect
    assert_equal I18n.t('devise.registrations.disabled'), flash[:alert]
  end

  test 'should not allow create a user' do
    post user_registration_path, params: { user: valid_user_params }

    assert_response :redirect
    assert_equal I18n.t('devise.registrations.disabled'), flash[:alert]
  end

  # test "should get new" do
  #   get new_user_registration_path
  #   assert_response :success
  # end

  # test "should create user with valid parameters" do
  #   assert_difference "User.count", 1 do
  #     assert_emails 1 do
  #       post user_registration_path, params: { user: valid_user_params }
  #     end
  #   end

  #   assert_redirected_to root_path
  #   assert_equal I18n.t("devise.registrations.signed_up_but_unconfirmed"), flash[:notice]
  # end

  # test "should not create user with invalid email format" do
  #   assert_no_difference "User.count" do
  #     post user_registration_path, params: {
  #       user: valid_user_params.merge(email: "invalid-email")
  #     }
  #   end

  #   assert_response :unprocessable_content
  #   assert_error_message I18n.t("errors.messages.invalid")
  # end

  # test "should not create user with too short password" do
  #   assert_no_difference "User.count" do
  #     post user_registration_path, params: {
  #       user: valid_user_params.merge(
  #         password: "123",
  #         password_confirmation: "123"
  #       )
  #     }
  #   end

  #   assert_response :unprocessable_content
  #   assert_error_message I18n.t("errors.messages.too_short", count: 6)
  # end

  # test "should not create user with mismatched password confirmation" do
  #   assert_no_difference "User.count" do
  #     post user_registration_path, params: {
  #       user: valid_user_params.merge(password_confirmation: "mismatch")
  #     }
  #   end

  #   assert_response :unprocessable_content
  #   assert_error_message I18n.t("errors.messages.confirmation", attribute: "Password")
  # end

  # test "should not create user with duplicate email" do
  #   existing_user = FactoryBot.create(:user, email: "existing@example.com")

  #   assert_no_difference "User.count" do
  #     post user_registration_path, params: {
  #       user: valid_user_params.merge(email: existing_user.email)
  #     }
  #   end

  #   assert_response :unprocessable_content
  #   assert_error_message I18n.t("errors.messages.taken")
  # end

  # test "should not create user with blank name" do
  #   assert_no_difference "User.count" do
  #     post user_registration_path, params: {
  #       user: valid_user_params.merge(name: "")
  #     }
  #   end

  #   assert_response :unprocessable_content
  #   assert_error_message I18n.t("errors.messages.blank")
  # end

  # test "should allow user to cancel account" do
  #   user = FactoryBot.create(:user)
  #   sign_in user

  #   assert_difference "User.count", -1 do
  #     delete user_registration_path
  #   end

  #   assert_redirected_to root_path
  #   assert_equal I18n.t("devise.registrations.destroyed"), flash[:notice]
  # end

  # private

  def valid_user_params
    {
      email: 'test@example.com',
      name: 'Test User',
      password: 'secure_password_123',
      password_confirmation: 'secure_password_123'
    }
  end
end
