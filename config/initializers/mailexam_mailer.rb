Rails.application.configure do
  next unless ENV["MAILEXAM_LOGIN"].present? && ENV["MAILEXAM_PASSWORD"].present?

  login = ENV.fetch("MAILEXAM_LOGIN")
  port = ENV.fetch("MAILEXAM_PORT", "587").to_i

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  config.action_mailer.smtp_settings = {
    address: "#{login}.mailexam.io",
    port: port,
    user_name: login,
    password: ENV.fetch("MAILEXAM_PASSWORD"),
    authentication: :plain,
    enable_starttls_auto: [587, 2525].include?(port),
  }

  config.action_mailer.default_options = {
    from: ENV.fetch("MAIL_FROM", "noreply@example.test"),
  }
end
