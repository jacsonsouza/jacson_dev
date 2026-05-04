class Users::Dashboard::WidgetsController < ApplicationController
  layout false

  def visits_over_time
    @period_in_days = params.fetch(:period, 7).to_i

    @visits_over_time = Dashboard::VisitsOverTime
                        .new(period_in_days: @period_in_days).call

    render template: 'users/dashboard/widgets/visits_over_time'
  end

  def projects_by_skill
    @project_skill_distribution = Dashboard::ProjectSkillDistribution.new.call

    render template: 'users/dashboard/widgets/projects_by_skill'
  end
end
