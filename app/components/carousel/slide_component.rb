# frozen_string_literal: true

class Carousel::SlideComponent < ViewComponent::Base
  attr_reader :title, :items, :partial, :as

  def initialize(title:, items:, partial:, as:, label: nil)
    super()
    @title = title
    @items = items
    @partial = partial
    @as = as
    @label = label
  end

  def label
    @label.presence || 'Continue exploring'
  end

  def render_items
    render partial:, collection: items, as:
  end
end
