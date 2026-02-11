class Users::BaseController < ApplicationController
  include Breadcrumbs

  layout 'users/admin'

  def render(*args)
    default_breadcrumbs
    super
  end

  private

  def default_breadcrumbs
    add_breadcrumb I18n.t('breadcrumbs.home'), users_root_path
    set_breadcrumbs if respond_to?(:set_breadcrumbs, true)
  end

  def set_resource_breadcrumbs(resource:, collection_path:, instance: nil)
    key = resource.to_s.pluralize

    add_breadcrumb t("breadcrumbs.#{key}.index"), collection_path

    case action_name.to_sym
    when :new
      add_breadcrumb t("breadcrumbs.#{key}.new")
    when :edit
      add_breadcrumb t("breadcrumbs.#{key}.edit", name: instance&.name)
    when :show
      add_breadcrumb instance&.name
    end
  end
end
