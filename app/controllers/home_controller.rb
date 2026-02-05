class HomeController < ApplicationController
  def index; end

  def about; end

  def skills
    @skills = Skill.by_category(params[:category])
                   .includes(:icon_attachment, :tags).order(name: :asc)
  end

  def projects
    @projects = Project.includes([:image_attachment, :skills])
                       .order(favorite: :desc, name: :asc)
  end

  def project
    @project = Project.find(params[:id])
  end

  def contact; end
end
