require 'test_helper'

class SkillTagTest < ActiveSupport::TestCase
  setup do
    skill = FactoryBot.create(:skill)
    tag = FactoryBot.create(:tag, name: 'test')
    @skill_tag = SkillTag.new(skill: skill, tag: tag)
  end

  context 'associations' do
    should belong_to(:skill)
    should belong_to(:tag)
  end
end
