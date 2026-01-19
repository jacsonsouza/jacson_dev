class HomeController < ApplicationController
  def index; end

  def about; end

  def skills
    @skills = Skill.by_category(params[:category])
                   .includes(:icon_attachment, :tags).order(name: :asc)
  end

  def projects; end

  def contact; end
end
