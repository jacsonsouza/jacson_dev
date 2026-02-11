require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  subject do
    FactoryBot.build(:project)
  end

  context 'validations' do
    should validate_presence_of(:name)
    should validate_length_of(:name).is_at_least(5)
    should validate_presence_of(:short_description)
    should validate_length_of(:short_description).is_at_least(20).is_at_most(200)
    should validate_comparison_of(:end_date).is_greater_than(:start_date)
    should allow_value(nil).for(:end_date)
    should allow_value('https://example.com').for(:url)
    should allow_value(nil).for(:url)
    should allow_value('https://github.com/jacsonsouza').for(:repository)
    should allow_value(nil).for(:repository)
  end

  context 'associations' do
    should belong_to(:user)
    should have_many(:skills).through(:project_skills)
    should have_one_attached(:image)
    should have_rich_text(:details)
  end

  context 'scope by_category' do
    setup do
      user = FactoryBot.create(:user)
      @web_project = FactoryBot.create(:project, category: 0, user: user)
      @mobile_project = FactoryBot.create(:project, category: 1, user: user)
    end

    should 'return only projects from a valid category' do
      result = Project.by_category('web')

      assert_includes result, @web_project
      assert_not_includes result, @mobile_project
    end

    should 'return all projects when category is not present' do
      result = Project.by_category(nil)

      assert_equal Project.count, result.count
    end
  end
end
