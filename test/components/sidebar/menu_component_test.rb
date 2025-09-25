# frozen_string_literal: true

require 'test_helper'

class Sidebar::MenuComponentTest < ViewComponent::TestCase
  def setup
    @user = FactoryBot.create(:user)
    @component = Sidebar::MenuComponent.new(current_user: @user)
  end

  def test_renders_component_structure
    render_inline(@component)

    assert_user_section
    assert_all_menu_sections
    assert_menu_items
  end

  def test_sidebar_functionality
    render_inline(@component)

    assert_selector "[data-controller='sidebar']"
    assert_selector "button[data-action='click->sidebar#toggleSidebar']"
    assert_selector "nav[data-sidebar-target='sidebar']"
  end

  private

  def assert_user_section
    assert_selector "img.avatar[alt='#{@user.name}']"
    assert_selector 'h2', text: @user.name
    assert_selector '.badge', text: I18n.t('users.menu.admin')
  end

  def assert_all_menu_sections
    sections = [
      I18n.t('users.menu.sections.main'),
      I18n.t('users.menu.sections.content'),
      I18n.t('users.menu.sections.settings')
    ]

    sections.each do |section|
      assert_selector "##{section}_section", text: section
    end
  end

  def assert_menu_items
    assert_menu_item('fas fa-home', I18n.t('users.menu.dashboard'))
    assert_menu_item('fas fa-sign-out-alt', I18n.t('users.menu.sign_out'))
  end

  def assert_menu_item(icon_class, text)
    assert_selector "i.#{icon_class.gsub(' ', '.')}"
    assert_text text
  end
end
