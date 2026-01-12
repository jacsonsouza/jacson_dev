require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context 'validations' do
    should validate_presence_of(:email)
    should validate_uniqueness_of(:email)
    should validate_presence_of(:name)
    should validate_length_of(:name).is_at_least(2)
    should validate_length_of(:name).is_at_most(50)
    should validate_presence_of(:password)
  end

  context 'associations' do
    should have_many(:skills)
  end

  test 'should not allow multiple users registered' do
    FactoryBot.create(:user)
    user_not_allowed = FactoryBot.build(:user)

    assert_not user_not_allowed.valid?
    assert_includes user_not_allowed.errors[:base], I18n.t('errors.messages.only_one_user')
  end
end
