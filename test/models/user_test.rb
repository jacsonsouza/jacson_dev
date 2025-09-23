require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.build(:user)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should be invalid" do
    @user.email = nil
    assert_not @user.valid?
  end
end
