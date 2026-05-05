require 'test_helper'

module Users::Dashboard::Widgets
  class VisitsOverTimesControllerTest < ActionDispatch::IntegrationTest
    setup do
      user = create(:user)
      sign_in user
    end

    test 'should responds successfully with default period' do
      get users_dashboard_widgets_visits_over_time_path

      assert_response :success

      assert_match(
        I18n.t('users.dashboard.widgets.visits_over_times.show.title'),
        response.body
      )
    end

    test 'should accepts custom period param' do
      get users_dashboard_widgets_visits_over_time_path, params: { period: 30 }

      assert_response :success
    end
  end
end
