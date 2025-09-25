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

  test 'should allow only one user registered' do
    assert @user.valid?
  end

  test 'should not allow multiple users registered' do
    @user.save
    @user_not_allowed = FactoryBot.build(:user)

    assert_not @user_not_allowed.valid?
    assert_includes @user_not_allowed.errors[:base], I18n.t('errors.messages.only_one_user')
  end
end
