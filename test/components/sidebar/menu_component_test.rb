# frozen_string_literal: true

require 'test_helper'

class Sidebar::MenuComponentTest < ViewComponent::TestCase
  def setup
    @user = FactoryBot.create(:user)
    @component = Sidebar::MenuComponent.new(current_user: @user)
  end

  def test_renders_component_structure
    render_inline(@component)

    assert_header
    assert_menu_items
  end

  def test_sidebar_functionality
    render_inline(@component)

    assert_selector "[data-controller='sidebar']"
  end

  private

  def assert_header
    assert_selector "img[alt='Logo']"
    assert_selector '#user-name', text: @user.first_name
  end

  def assert_menu_items
    items.each do |item|
      assert_menu_item(item[:icon], item[:name])
    end
  end

  def items
    [
      { icon: :house, name: I18n.t('users.menu.dashboard') },
      { icon: :briefcase, name: I18n.t('users.menu.projects') },
      { icon: :code, name: I18n.t('users.menu.skills') },
      { icon: :envelope, name: 'Messages' }
    ]
  end

  def assert_menu_item(icon, text)
    assert_selector "svg[data-icon='#{icon}']"
    assert_text text
  end
end
