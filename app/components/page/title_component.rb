# frozen_string_literal: true

class Page::TitleComponent < ViewComponent::Base
  def initialize(title:, path: nil, label: nil, icon: nil)
    super()
    @title = title
    @path = path
    @label = label
    @icon = icon
  end

  def label
    @label || t('links.new', resource: @title.singularize)
  end

  def icon
    @icon || 'fas fa-plus'
  end
end
