require 'test_helper'

module Users::Dashboard::Widgets
  class VisitsOverTimesTest < ActionView::TestCase
    include Users::Dashboard::Widgets::VisitsOverTimesHelper

    test 'should return the options to filter by period' do
      assert_equal expected_options, visits_over_time_period_options
    end

    private

    def expected_options
      expected_scope = 'users.dashboard.widgets.visits_over_times.show.periods'

      [
        [t("#{expected_scope}.7_days"), 7],
        [t("#{expected_scope}.30_days"), 30]
      ]
    end
  end
end
