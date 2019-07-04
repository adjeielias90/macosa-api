class InvitationMailer < ApplicationMailer
  def invite_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: 'Macosa Invitation - Welcome to Macosa')
  end
end
