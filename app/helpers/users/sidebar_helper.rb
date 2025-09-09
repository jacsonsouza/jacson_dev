module Users::SidebarHelper
  def main_items
    [
      { icon: "fas fa-home", name: t('users.menu.dashboard'), path: '' },
      { icon: "fas fa-user", name: t('users.menu.profile'), path: '' },
    ].freeze
  end

  def content_items
    [
      { icon: "fas fa-briefcase", name: t('users.menu.projects'), path: '' },
      { icon: "fas fa-code", name: t('users.menu.skills'), path: '' },
      { icon: "fas fa-newspaper", name: t('users.menu.blog'), path: '' },
    ].freeze
  end

  def settings_items
    [
      { icon: "fas fa-envelope", name: t('users.menu.settings'), path: '' },
      { icon: "fas fa-sign-out-alt", name: t('users.menu.sign_out'), path: destroy_user_session_path, method: :delete }
    ].freeze
  end
end