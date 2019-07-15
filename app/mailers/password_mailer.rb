class PasswordMailer < ApplicationMailer
  def invite_email(user)
    @user = invitation
    mail(to: @user.email, subject: 'Macosa Mailer - Password Reset Notice')
  end
end
