class UserMailerPreview < ActionMailer::Preview
  def reset_password_email
    user = User.first
    Devise::Mailer.reset_password_instructions(user, user.reset_password_token)
  end

  def confirmation_instructions
    user = User.first
    Devise::Mailer.confirmation_instructions(user, user.confirmation_token)
  end

  def unlock_instructions
    user = User.first
    Devise::Mailer.unlock_instructions(user, user.unlock_token)
  end
end
