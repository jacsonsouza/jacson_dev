class SkillsController < ApplicationController
  before_action :set_user

  def index
    @skills = @user.skills
                   .by_category(params[:category])
                   .includes(:icon_attachment).order(name: :asc)
  end

  private

  def set_user
    @user = User.first
  end
end
