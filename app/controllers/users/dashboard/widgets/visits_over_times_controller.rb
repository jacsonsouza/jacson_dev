class Users::Dashboard::Widgets::VisitsOverTimesController < ApplicationController
  layout false

  def show
    @period_in_days = params.fetch(:period, 7).to_i

    @visits_over_time = Dashboard::VisitsOverTime
                        .new(period_in_days: @period_in_days).call
  end
end
