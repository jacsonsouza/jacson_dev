require 'test_helper'

class Dashboard::VisitsOverTimeTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @skills = create_list(:skill, 3, user: @user)
  end

  test 'should return projects count grouped by skill' do
    create(:project, user: @user, skills: @skills)

    expected = {
      @skills.first.name => 1,
      @skills.second.name => 1,
      @skills.third.name => 1
    }

    assert_equal expected, Dashboard::ProjectSkillDistribution.new.call
  end

  test 'should return the correct projects count per skill' do
    main_skill = @skills.first
    other_skills = [@skills.second, @skills.last]

    create_list(:project, 3, user: @user, skills: [main_skill])
    create_list(:project, 2, user: @user, skills: other_skills)

    expected = {
      main_skill.name => 3,
      other_skills.first.name => 2,
      other_skills.last.name => 2
    }

    result = Dashboard::ProjectSkillDistribution.new.call

    assert_equal expected, result
  end

  test 'should not count projects without skills' do
    create(:project, user: @user)

    assert_empty Dashboard::ProjectSkillDistribution.new.call
  end
end
