class Users::Devise::SessionsController < Devise::SessionsController
  layout 'devise/sessions'

  def after_sign_in_path_for(_resource)
    users_root_path
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end
end
