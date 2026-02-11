# frozen_string_literal: true

require 'test_helper'

class Page::TitleComponentTest < ViewComponent::TestCase
  def test_component_renders_title
    render_inline(Page::TitleComponent.new(title: 'Test Title'))

    assert_selector('h1', text: 'Test Title')
  end

  def test_component_should_render_a_link_if_url_is_provided
    render_inline(Page::TitleComponent.new(title: 'Test Title', path: 'https://example.com'))

    assert_selector('h1', text: 'Test Title')
    assert_selector('a[href="https://example.com"]')
  end

  def test_component_should_render_the_button_with_the_correct_label_and_icon
    render_inline(
      Page::TitleComponent.new(title: 'Test Title',
                               path: 'https://example.com',
                               label: 'Click Me',
                               icon: 'fa fa-pencil')
    )

    assert_selector('a', text: 'Click Me')
    assert_selector('i.fa.fa-pencil')
  end
end
