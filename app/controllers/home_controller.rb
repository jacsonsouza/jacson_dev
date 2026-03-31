class HomeController < ApplicationController
  def index; end

  def about; end

  def skills
    @skills = Skill.by_category(params[:category])
                   .includes(:icon_attachment).order(name: :asc)
  end

  def projects
    @projects = Project.by_category(params[:category])
                       .includes(:skills)
                       .order(favorite: :desc, name: :asc)
  end

  def project
    @project = Project.find(params[:id])
  end

  def contact; end
end
