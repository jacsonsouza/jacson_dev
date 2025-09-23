require "application_system_test_case"

class UserSessionsTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test "should display login form" do
    visit new_user_session_path

    assert_selector "h1", text: I18n.t("links.sign_in")

    within("form") do
      assert_selector 'input[name="user[email]"]'
      assert_selector 'input[name="user[password]"]'
    end
  end

  test "should sign in with valid credentials" do
    visit new_user_session_path

    within("form") do
      fill_in "user[email]", with: @user.email
      fill_in "user[password]", with: @user.password
    end

    click_button I18n.t("links.sign_in")

    assert_flash I18n.t("devise.sessions.signed_in")
    assert_current_path users_root_path
  end

  test "should reject authentication with invalid credentials" do
    visit new_user_session_path

    within("form") do
      fill_in "user[email]", with: @user.email
      fill_in "user[password]", with: "invalid"
    end

    click_button I18n.t("links.sign_in")

    assert_flash I18n.t("devise.failure.invalid", authentication_keys: "Email")
  end

  test "should sign out when user is signed in" do
    sign_in @user

    visit users_root_path

    click_link I18n.t("users.menu.sign_out")

    assert_flash I18n.t("devise.sessions.signed_out")
  end
end
