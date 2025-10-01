class Users::SkillsController < ApplicationController
  layout 'users/dashboard'

  def index
    @skills = Skill.all
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = current_user.skills.build(skill_params)
    if @skill.save
      redirect_to users_skills_path
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def skill_params
    params.expect(skill: [:name, :description, :proficiency, :icon])
  end
end
