require 'test_helper'

class TagTest < ActiveSupport::TestCase
  setup do
    @tag = FactoryBot.create(:tag)
  end

  context 'validations' do
    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)
  end

  context 'associations' do
    should have_many(:skills)
  end
end
