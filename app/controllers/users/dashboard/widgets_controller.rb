class Users::Dashboard::WidgetsController < ApplicationController
  layout false

  before_action :set_period

  def views_chart
    days_count = @period.to_i
    start_date = days_count.days.ago.beginning_of_day

    @views_velocity = Ahoy::Visit
                      .where(started_at: start_date..Time.current)
                      .group_by_day(:started_at, range: start_date..Time.current)
                      .count

    render template: 'users/dashboard/widgets/views_chart'
  end

  def projects_by_skill
    @skill_distribution = Project.joins(:skills).group('skills.name').count
    render template: 'users/dashboard/widgets/projects_by_skill'
  end

  private

  def set_period
    @period = params[:period] || '7'
  end
end
