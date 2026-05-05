require 'test_helper'

module Users::Dashboard::Widgets
  class ProjectSkillDistributionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      user = create(:user)
      sign_in(user)
    end

    test 'renders successfully' do
      get users_dashboard_widgets_project_skill_distribution_path

      assert_response :success

      assert_match(
        I18n.t('users.dashboard.widgets.project_skill_distributions.show.title'),
        response.body
      )
    end
  end
end
