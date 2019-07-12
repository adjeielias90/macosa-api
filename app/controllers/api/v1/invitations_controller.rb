class Api::V1::InvitationsController < Api::V1::BaseController
  # Authorize request before processing
  before_action :authenticate_request!

  def index
    # invitations = Invitation.all


    if params[:token] && (invitation = Invitation.where(token: params[:token]).first)
      if invitation.email_confirmed?
        render json: {invitation: invitation}, status: :ok
      else
        render json: {errors: "Email not verified"}, status: :unauthorized
      end
    else
      @invitations = Invitation.all
      render json: {invitations: @invitations }, status: :ok
    end
  end

  def create
    @owner = Owner.first
    if @current_user.email == @owner.email
    # @admin = current_user
      if Invitation.exists?(email: params[:email])
        render json: {duplicate: 'Invitation has been sent to this email already.'}, status: :ok
      else
        if @owner
          invitation = @owner.invitations.new(invitation_params)
          invitation.generate_invitation_instructions!
          if invitation.save
            @invitation = invitation
            #Invoke send invitation email function here
            if InvitationMailer.invite_email(@invitation).deliver_now
              render json: {invitation: @invitation}, status: :created
            else
              render json: {status: 'An error occured while trying to send invitation mail'}, status: :bad_request
            end
          else
            render json: {errors: invitation.errors.full_messages}, status: :bad_request
          end
        else
          render json: {error: @owner.errors.full_messages}, status: :ok
        end
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :bad_request
    end
  end



  def show
    if @current_user.is_admin?
      @invitation = Invitation.find_by(token: params[:token].to_s.downcase)
      if @invitation
        if @invitation.email_confirmed?
          render json: {invitation: @invitation}, status: :ok
        else
          render json: {errors: "Email not verified"}, status: :unauthorized
        end
      elsif @invitation.nil
        render json: {errors: @invitation.errors.full_messages}, status: :bad_request
      else
        render json: {errors: @invitation.errors.full_messages}, status: :bad_request
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end

  end



private
  def invitation_params
    params.require(:invitation).permit(:email, :firstname, :lastname, :is_admin, :token)
  end
end