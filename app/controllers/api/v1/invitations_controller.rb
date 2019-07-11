class Api::V1::InvitationsController < Api::V1::BaseController
  # Authorize request before processing
  before_action :authenticate_request!

  def index
    @invitations = Invitation.all
    render json: {invitations: @invtations }, status: :ok
  end



  def show
    if @current_user.is_admin?

      if invitation = Invitation.find_by(token: params[:id].to_s.downcase)
        if invitation.email_confirmed?
          render json: {invitation: invitation}, status: :ok
        else
          render json: {errors: "Email not verified"}, status: :unauthorized
        end
      else
        render json: {errors: invitation.errors.full_messages}, status: :bad_request
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end
end