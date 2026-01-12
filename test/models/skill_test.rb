require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  setup do
    @skill = FactoryBot.create(:skill)
  end

  context 'validations' do
    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)
    should validate_length_of(:name).is_at_most(50)
    should validate_presence_of(:description)
    should validate_presence_of(:icon)
    should validate_length_of(:short_description).is_at_least(10)
    should validate_numericality_of(:proficiency).is_in(0..100)
    should define_enum_for(:category).with_values(Skill.categories)
    should allow_value('#000000').for(:color)
    should_not allow_value('invalid').for(:color)
  end

  context 'associations' do
    should belong_to(:user)
    should have_many(:skill_tags)
    should have_many(:tags).through(:skill_tags)
    should have_one_attached(:icon)
  end

  test 'should creates and associates a new tag when tag does not exist' do
    @skill.tags << FactoryBot.build(:tag, name: 'test')

    assert_equal 2, @skill.tags.count
    assert_equal 'test', @skill.tags.last.name
  end
end
