require 'test_helper'

class Dashboard::VisitsOverTimeTest < ActiveSupport::TestCase
  test 'should returns visits grouped by day including days without visits' do
    travel_to Time.zone.local(2026, 5, 5, 12) do
      create_visits_on %w[2026-05-04 2026-05-04 2026-05-03 2026-04-25]

      expected_visits = expected_visits_over(
        7, {
          '2026-05-03' => 1,
          '2026-05-04' => 2
        }
      )

      assert_equal expected_visits, visits_over_time
    end
  end

  test 'respects custom period in days' do
    travel_to Time.zone.local(2026, 5, 5, 12) do
      create_visits_on %w[2026-05-04 2026-05-04 2026-05-03 2026-04-25]

      expected_visits = expected_visits_over(
        3, {
          '2026-05-03' => 1,
          '2026-05-04' => 2
        }
      )

      assert_equal expected_visits, visits_over_time(period_in_days: 3)
    end
  end

  private

  def visits_over_time(period_in_days: 7)
    Dashboard::VisitsOverTime.new(period_in_days: period_in_days).call
  end

  def create_visits_on(dates)
    dates.each do |date|
      create(:ahoy_visit, started_at: Time.zone.parse("#{date} 12:00"))
    end
  end

  def expected_visits_over(days, visits_by_date = {})
    expected_range(days).index_with do |date|
      visits_by_date.fetch(date.to_s, 0)
    end
  end

  def expected_range(days)
    days.days.ago.to_date..Time.zone.today
  end
end
