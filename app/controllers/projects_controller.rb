class ProjectsController < ApplicationController
  before_action :set_user

  def index
    @projects = @user.projects.by_category(params[:category])
                     .includes(:skills)
                     .order(favorite: :desc, name: :asc)
  end

  def show
    @project = @user.projects.find(params[:id])
  end

  private

  def set_user
    @user = User.first
  end
end
