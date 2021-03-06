class Api::V1::InvitationsController < Api::V1::BaseController
  # Authorize request before processing
  # app crashing
  # before_action :authenticate_request!, except: [:show, :index]

  # configure wrap parameters on model
  # wrap_parameters :invitation, include: %i[email firstname lastname is_admin]
  before_action :authenticate_request!, except: [:show, :index]
  def index
    # invitations = Invitation.all
    if params[:token]
      if invitation = Invitation.find_by(token: params[:token].to_s.downcase)
        if invitation.email_confirmed?
          render json: invitation, status: :ok
        else
          render json: {errors: "Email not verified"}, status: :unauthorized
        end
      else
        render json: {invitation: {}}, status: :ok
      end
    elsif !params[:token]
      @invitations = Invitation.all
      render json:  @invitations, status: :ok
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
              render json: @invitation, status: :created
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
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  def update
    render json: {error: "You cannot edit an invitation"}, status: :unauthorized
  end


  def show
    # if current_user.is_admin?
      @invitation = Invitation.find_by(token: params[:id].to_s.downcase)
      if @invitation
        if @invitation.email_confirmed?
          render json: @invitation, status: :ok
        else
          render json: {errors: "Email not verified"}, status: :unauthorized
        end
      else
        render json: {invitation: {}}, status: :ok
      end
    # else
    #   render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    # end

  end



private
  def invitation_params
    params.require(:invitation).permit(:email, :firstname, :lastname, :is_admin, :token)
  end
end