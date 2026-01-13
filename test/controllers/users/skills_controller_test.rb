require 'test_helper'

class Users::SkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @skill = FactoryBot.create(:skill, user: @user)

    sign_in @user
  end

  test 'should allow access when signed in' do
    assert_access_to [
      users_skills_path,
      new_users_skill_path,
      edit_users_skill_path(@skill)
    ]
  end

  test 'should create a new skill for the user' do
    new_skill = FactoryBot.build(:skill, user: @user)

    assert_difference('Skill.count') do
      post users_skills_path,
           params: { skill: { name: new_skill.name,
                              category: new_skill.category,
                              color: new_skill.color,
                              short_description: new_skill.short_description,
                              description: new_skill.description,
                              proficiency: new_skill.proficiency,
                              icon: icon_file } }

      assert_response :redirect
      assert_notice I18n.t('notices.create', resource: new_skill.model_name.human)
    end
  end

  test 'should edit a skill for the user' do
    patch users_skill_path(@skill),
          params: { skill: { name: 'New name' } }

    assert_response :redirect
    assert_notice I18n.t('notices.update', resource: @skill.model_name.human)
  end

  test 'should destroy a skill for the user' do
    assert_difference('Skill.count', -1) do
      delete users_skill_path(@skill)
    end

    assert_response :redirect
    assert_notice I18n.t('notices.destroy', resource: @skill.model_name.human)
  end

  test 'should not create a new skill with invalid data' do
    assert_no_difference('Skill.count') do
      post users_skills_path,
           params: { skill: { name: '' } }
    end

    assert_response :unprocessable_content
  end

  test 'should not update a skill with invalid data' do
    patch users_skill_path(@skill),
          params: { skill: { name: '' } }

    assert_response :unprocessable_content
  end

  private

  def icon_file
    Rack::Test::UploadedFile.new(
      Rails.root.join('test/fixtures/files/logo.png').to_s, 'image/png'
    )
  end

  def assert_notice(message)
    assert_equal message, flash[:notice]
  end
end
