return if Rails.env.test?

Rails.application.configure do
  config.action_mailer.delivery_method = :smtp

  mailer = Rails.application.credentials.mailer
  config.action_mailer.smtp_settings = {
    domain: mailer&.domain,
    user_name: mailer&.user_name,
    password: mailer&.password,
    address: mailer&.address,
    host: mailer&.host,
    port: mailer&.port,
    authentication: :login
  }
end