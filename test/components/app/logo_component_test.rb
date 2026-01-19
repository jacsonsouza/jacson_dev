# frozen_string_literal: true

require 'test_helper'

class App::LogoComponentTest < ViewComponent::TestCase
  def test_component_renders_the_logo_icon
    render_inline(App::LogoComponent.new)

    image_tag = page.find('img')

    assert_equal I18n.t('app.name'), image_tag[:alt]
  end

  def test_component_renders_the_logo_text
    render_inline(App::LogoComponent.new)

    assert_selector 'span', text: I18n.t('app.name')
  end

  def test_component_renders_with_custom_classes
    render_inline(App::LogoComponent.new(text_class: 'text-3xl', icon_class: 'h-10'))

    assert_selector 'div', class: 'text-3xl'
    assert_selector 'img', class: 'h-10'
  end
end
