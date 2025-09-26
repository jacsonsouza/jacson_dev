class Users::Devise::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  layout 'devise/sessions'

  def new
    redirect_to user_session_path, alert: t('devise.registrations.disabled')
  end

  def create
    redirect_to user_session_path, alert: t('devise.registrations.disabled')
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
