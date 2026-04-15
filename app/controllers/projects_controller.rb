class ProjectsController < ApplicationController
  before_action :set_user

  def index
    @projects = @user.projects.by_category(params[:category])
                     .includes(skills: [:icon_attachment])
                     .order(favorite: :desc, name: :asc)
  end

  def show
    @project = @user.projects.includes({ skills: [:icon_attachment] }, :image_attachment).find(params[:id])
    @related_projects = @project.related_projects
  end

  private

  def set_user
    @user = User.first
  end
end
