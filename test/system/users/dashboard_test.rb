require 'application_system_test_case'

class Users::DashboardTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    @skill = create(:skill, user: @user)
    @projects = create_list(:project, 3, user: @user, skills: [@skill])

    sign_in(@user)
  end

  test 'user sees dashboard with main widgets' do
    visit users_root_path

    assert_selector '#projects-chart'
    assert_selector '#visits_over_time'
    assert_selector '#project_skill_distribution'
  end

  test 'user sees project count' do
    visit users_root_path

    within '#projects-chart' do
      assert_selector '#chart-title',
                      text: t_dashboard('index.charts.projects')

      assert_selector '#chart-value',
                      text: @projects.count.to_s
    end
  end

  test 'user sees visits over time chart with default period' do
    visit users_root_path

    within '#visits_over_time' do
      assert_text t_dashboard('widgets.visits_over_times.show.title')

      assert_selector 'option[selected]',
                      text: t_dashboard('widgets.visits_over_times.show.periods.7_days')

      assert_selector 'canvas'
    end
  end

  test 'changing period updates chart' do
    period_in_days = 30

    visit users_root_path

    within '#visits_over_time' do
      select period_in_days, from: 'period'

      assert_text t_dashboard('widgets.visits_over_times.show.periods.30_days')

      assert_selector '#visits_over_time_subtitle',
                      text: t_dashboard('widgets.visits_over_times.show.subtitle', days: period_in_days)
    end
  end

  test 'user sees project skill distribution chart' do
    visit users_root_path

    within '#project_skill_distribution' do
      assert_selector '#project_skill_distribution_title',
                      text: t_dashboard('widgets.project_skill_distributions.show.title')

      assert_selector 'canvas'
    end
  end

  private

  def t_dashboard(key, options = {})
    I18n.t(key, scope: 'users.dashboard', **options).upcase
  end
end
