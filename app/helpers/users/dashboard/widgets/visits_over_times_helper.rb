module Users::Dashboard::Widgets::VisitsOverTimesHelper
  def visits_over_time_period_options
    scope = 'users.dashboard.widgets.visits_over_times.show.periods'

    [
      [t("#{scope}.7_days"), 7],
      [t("#{scope}.30_days"), 30]
    ]
  end
end
