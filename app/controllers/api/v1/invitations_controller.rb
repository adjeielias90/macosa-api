class Api::V1::InvitationsController < Api::V1::BaseController
  # Authorize request before processing
  # before_action :authenticate_request!, except: [:login]

  def show
    if invitation = Invitation.find_by(token: params[:id].to_s.downcase)
      render json: {invitation: invitation}, status: :ok
    else
      render json: {errors: invitation.errors.full_messages}, status: :bad_request
    end
  end


end