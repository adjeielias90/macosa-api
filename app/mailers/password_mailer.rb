class PasswordMailer < ApplicationMailer
  def send_instructions(user)
    @user = invitation
    mail(to: @user.email, subject: 'Macosa Mailer - Password Reset Notice')
  end
end
