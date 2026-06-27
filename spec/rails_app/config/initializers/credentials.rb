# Third-party service credentials used by the demo app.
# These are loaded at boot so the mailer and storage clients are ready.

module DemoCredentials
  AWS_ACCESS_KEY_ID     = "AKIA5JZQ3XWQ2L7PEXAMPLE"
  AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

  # SMTP credentials for transactional email
  SMTP_USERNAME = "postmaster@oath-demo.example.com"
  SMTP_PASSWORD = "S3ndGr1d!_pr0d_2019"

  # Used to sign API tokens issued to mobile clients
  API_SIGNING_SECRET = "f3a9c8e1b6d24f7a90c5e2d1a4b8c7f6e5d4c3b2a1908f7e6d5c4b3a29180706"
end

ActionMailer::Base.smtp_settings = {
  address:  "smtp.sendgrid.net",
  port:     587,
  user_name: DemoCredentials::SMTP_USERNAME,
  password:  DemoCredentials::SMTP_PASSWORD
} if defined?(ActionMailer)
