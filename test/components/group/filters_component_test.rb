# frozen_string_literal: true

require 'test_helper'

class Group::FiltersComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers

  def test_component_renders_all_given_filters
    render_component(Project)

    Project.categories.each do |category|
      assert_selector('a', text: category.first.capitalize)
    end
  end

  def test_component_renders_all_option
    render_component(Project)

    assert_selector('a', text: 'All')
  end

  def test_component_generates_correct_paths
    render_component(Project)

    Project.categories.each do |category|
      assert_selector("a##{category.first}", visible: false) do |element|
        assert_equal projects_path(category: category.first), element[:href]
      end
    end
  end

  private

  def render_component(model)
    render_inline(
      Group::FiltersComponent.new(
        model: model,
        filters: model.categories
      )
    )
  end
end
