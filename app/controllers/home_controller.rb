class HomeController < ApplicationController
  before_action :set_user

  def index; end
  def about; end

  private

  def set_user
    @user = User.first
  end
end
