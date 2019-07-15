class PasswordMailer < ApplicationMailer
  def send_instructions(user)
    @user = user
    mail(to: @user.email, subject: 'Macosa Mailer - Password Reset Notice')
  end
end
