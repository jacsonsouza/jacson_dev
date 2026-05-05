module Users::Dashboard::Widgets
  class ProjectSkillDistributionsController < ApplicationController
    layout false

    def show
      @project_skill_distribution = Dashboard::ProjectSkillDistribution.new.call
    end
  end
end
