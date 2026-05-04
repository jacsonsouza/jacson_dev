class Users::Dashboard::WidgetsController < ApplicationController
  layout false

  def visits_over_time
    period_in_days = (params[:period] || '7').to_i

    @visits_over_time = Dashboard::VisitsOverTime
                        .new(period_in_days: period_in_days).call

    render template: template_for('visits_over_time')
  end

  def projects_by_skill
    @skill_distribution = Project.joins(:skills)
                                 .group('skills.name')
                                 .count

    render template: template_for('projects_by_skill')
  end

  private

  def template_for(widget)
    "users/dashboard/widgets/#{widget}"
  end
end
