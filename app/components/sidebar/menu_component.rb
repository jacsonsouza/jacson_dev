# frozen_string_literal: true

class Sidebar::MenuComponent < ViewComponent::Base
  MenuItem = Struct.new(:icon, :name, :path, :method_type)

  def initialize(current_user:)
    super()
    @current_user = current_user
  end

  def items
    main_items
  end

  private

  attr_reader :current_user

  def main_items
    [
      menu_item(icon: 'fas fa-home', name: t('users.menu.dashboard'), path: users_root_path),
      menu_item(icon: 'fas fa-briefcase', name: t('users.menu.projects'), path: users_projects_path),
      menu_item(icon: 'fas fa-code',      name: t('users.menu.skills'),   path: users_skills_path),
      menu_item(icon: 'fas fa-envelope', name: t('users.menu.messages'), path: '#')
    ]
  end

  def menu_item(icon:, name:, path:, method_type: nil)
    MenuItem.new(icon: icon, name: name, path: path.presence, method_type: method_type)
  end
end
