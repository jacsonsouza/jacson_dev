class HomeController < ApplicationController
  def index; end

  def about; end

  def skills
    @skills = Skill.includes(:icon_attachment, :tags, :rich_text_description)
  end

  def portfolio; end

  def contact; end
end
