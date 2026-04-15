require 'test_helper'

class SkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @skills = create_list(:skill, 3, user: @user)
  end

  test 'should render user skills' do
    get skills_path

    assert_response :success

    @skills.each do |skill|
      assert_match skill.name, response.body
    end
  end
end
