# frozen_string_literal: true

class Sidebar::MenuComponent < ViewComponent::Base
  MenuItem = Struct.new(:icon, :name, :path, :method_type)

  def initialize(current_user:)
    super()
    @current_user = current_user
  end

  def sections
    main_items
  end

  private

  attr_reader :current_user

  def build_sections
    [
      { items: main_items, name: t('users.menu.sections.main') }
    ]
  end

  def main_items
    [
      menu_item(icon: 'fas fa-home', name: t('users.menu.dashboard'), path: users_root_path),
      menu_item(icon: 'fas fa-briefcase', name: t('users.menu.projects'), path: users_projects_path),
      menu_item(icon: 'fas fa-code',      name: t('users.menu.skills'),   path: users_skills_path),
      menu_item(icon: 'fas fa-envelope', name: 'Messages', path: '#')
    ]
  end

  def content_items
    [
      menu_item(icon: 'fas fa-briefcase', name: t('users.menu.projects'), path: users_projects_path),
      menu_item(icon: 'fas fa-code',      name: t('users.menu.skills'),   path: users_skills_path),
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
