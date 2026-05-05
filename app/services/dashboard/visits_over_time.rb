class Dashboard::VisitsOverTime
  def initialize(period_in_days: 7)
    @period_in_days = period_in_days
  end

  def call
    Ahoy::Visit
      .where(started_at: time_range)
      .group_by_day(:started_at, range: time_range)
      .count
  end

  private

  def time_range
    @time_range ||= start_time..Time.current
  end

  def start_time
    @period_in_days.days.ago.beginning_of_day
  end
end
