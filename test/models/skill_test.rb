require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  context 'validations' do
    setup do
      @skill = FactoryBot.create(:skill)
    end

    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)
    should validate_length_of(:name).is_at_most(100)
    should validate_presence_of(:description)
    should validate_presence_of(:icon)
    should validate_length_of(:short_description).is_at_least(10)
    should validate_numericality_of(:proficiency).is_in(0..100)
    should define_enum_for(:category).with_values(Skill.categories)
    should allow_value('#000000').for(:color)
    should_not allow_value('invalid').for(:color)
  end

  context 'associations' do
    setup do
      @skill = FactoryBot.create(:skill)
    end

    should belong_to(:user)
    should have_many(:skill_tags)
    should have_many(:tags).through(:skill_tags)
    should have_one_attached(:icon)

    should 'creates and associates a new tag when tag does not exist' do
      @skill.tags << FactoryBot.build(:tag, name: 'test')

      assert_equal 1, @skill.tags.count
      assert_equal 'test', @skill.tags.last.name
    end
  end

  context 'scope by_category' do
    setup do
      user = FactoryBot.create(:user)
      @backend = FactoryBot.create(:skill, category: 0, user: user)
      @frontend = FactoryBot.create(:skill, category: 1, user: user)
      @mobile = FactoryBot.create(:skill, category: 2, user: user)
    end

    should 'return only skills from a valid category' do
      result = Skill.by_category('backend')

      assert_includes result, @backend
      assert_not_includes result, @frontend
      assert_not_includes result, @mobile
    end

    should 'return all skills when category is invalid' do
      result = Skill.by_category(999)

      assert_equal Skill.count, result.count
    end
  end
end
