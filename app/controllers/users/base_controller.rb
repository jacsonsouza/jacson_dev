class Users::BaseController < ApplicationController
  include Breadcrumbs

  layout 'users/dashboard'

  def render(*args)
    default_breadcrumbs
    super
  end

  private

  def default_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.home'), users_root_path
    set_breadcrumbs if respond_to?(:set_breadcrumbs, true)
  end
end
