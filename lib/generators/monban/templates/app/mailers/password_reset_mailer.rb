class PasswordResetMailer < ActionMailer::Base
  default from: "noreply@example.com" # NOTE: You'll want to change this

  def change_password(password_reset)
    @password_reset = password_reset
    @user = password_reset.user

    mail(
      to: @user.email,
      subject: 'Change your password'
    )
  end
end
