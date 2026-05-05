module Users::Dashboard::Widgets::VisitsOverTimeHelper
  def visits_over_time_period_options
    [
      [t('.periods.7_days'), 7],
      [t('.periods.30_days'), 30]
    ]
  end
end
