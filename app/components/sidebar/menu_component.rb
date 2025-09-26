# frozen_string_literal: true

class Sidebar::MenuComponent < ViewComponent::Base
  MenuItem = Struct.new(:icon, :name, :path, :method_type, keyword_init: true)

  def initialize(current_user: nil)
    @current_user = current_user
    super
  end

  def sections
    @sections ||= build_sections.freeze
  end

  private

  def build_sections
    [
      { items: main_items,     name: t('users.menu.sections.main') },
      { items: content_items,  name: t('users.menu.sections.content') },
      { items: settings_items, name: t('users.menu.sections.settings') }
    ]
  end

  def main_items
    [
      menu_item(icon: 'fas fa-home', name: t('users.menu.dashboard'), path: '#'),
      menu_item(icon: 'fas fa-user', name: t('users.menu.profile'),   path: '#')
    ]
  end

  def content_items
    [
      menu_item(icon: 'fas fa-briefcase', name: t('users.menu.projects'), path: '#'),
      menu_item(icon: 'fas fa-code',      name: t('users.menu.skills'),   path: '#'),
      menu_item(icon: 'fas fa-newspaper', name: t('users.menu.blog'),     path: '#')
    ]
  end

  def settings_items
    [
      menu_item(icon: 'fas fa-envelope',      name: t('users.menu.settings'), path: '#'),
      menu_item(icon: 'fas fa-sign-out-alt',  name: t('users.menu.sign_out'), path: destroy_user_session_path,
                method_type: :delete)
    ]
  end

  def menu_item(icon:, name:, path:, method_type: nil)
    MenuItem.new(icon: icon, name: name, path: path.presence, method_type: method_type)
  end
end
