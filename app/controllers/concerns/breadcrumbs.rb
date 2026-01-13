module Breadcrumbs
  extend ActiveSupport::Concern

  included do
    helper_method :breadcrumbs
  end

  private

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, path = nil)
    breadcrumbs << Breadcrumb.new(name, path)
  end
end

class Breadcrumb
  attr_reader :name, :path

  def initialize(name, path)
    @name = name
    @path = path
  end

  def link?
    @path.present?
  end
end
