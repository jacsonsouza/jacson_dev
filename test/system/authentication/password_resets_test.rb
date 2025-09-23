require "application_system_test_case"

class PasswordResetsTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test "should send reset password instructions" do
    visit new_user_password_path

    within("form") do
      fill_in "user[email]", with: @user.email
      click_on I18n.t("links.send_me_reset_password_instructions")
    end

    assert_flash I18n.t("devise.passwords.send_instructions")
  end

  test "should display error for invalid email when sending reset password instructions" do
    visit new_user_password_path

    within "form" do
      fill_in "user[email]", with: "invalid_email"
      click_on I18n.t("links.send_me_reset_password_instructions")
    end

    within ".user_email" do
      assert_text I18n.t("errors.messages.not_found")
    end
  end

  test "should reset password with valid token" do
    token = @user.send_reset_password_instructions
    visit edit_user_password_path(reset_password_token: token)

    within("form") do
      fill_in "user[email]", with: @user.email
      fill_in "user[password]", with: "new_password"
      fill_in "user[password_confirmation]", with: "new_password"
      click_on I18n.t("links.reset_password")
    end

    assert_flash I18n.t("devise.passwords.updated")
  end

  test "should display errors for mismatch password and password confirmation" do
    token = @user.send_reset_password_instructions
    visit edit_user_password_path(reset_password_token: token)

    within("form") do
      fill_in "user[email]", with: @user.email
      fill_in "user[password]", with: "new_password"
      fill_in "user[password_confirmation]", with: "wrong_password"
      click_on I18n.t("links.reset_password")
    end

    within ".user_password_confirmation" do
      assert_text I18n.t("errors.messages.confirmation", attribute: "Password")
    end
  end
end
