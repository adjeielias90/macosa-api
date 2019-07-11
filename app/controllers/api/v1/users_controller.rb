class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show, :update, :destroy]
  # Authorize request before processing
  before_action :authenticate_request!, except: [:login, :confirm_email]

  def index
    @users = User.all
    render json: {users: @users }
  end

  def create
    @owner = Owner.first
    if @current_user.is_admin?
    # @admin = current_user
      if @owner
        if invitation = Invitation.find_by(email: params[:email].to_s.downcase)
          if invitation.email_confirmed?
            user = @owner.users.new(user_params)
            invitation.destroy
            # user.generate_confirmation_instructions!
            if user.save
              #Invoke email function here
              render json: {status: 'User created successfully'}, status: :created
            else
              render json: {errors: user.errors.full_messages}, status: :bad_request
            end
          else
            render json: {errors: "User invited, but email not confirmed"}, status: :unauthorized
          end
        else
          render json: {error: "User has not yet been invited"}, status: :bad_request
        end
      else
        render json: {error: @owner.errors.full_messages}
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
    # @tenant = @owner.create_tenant(name: tenant_params[:company_name])
  end


  def login
    if @user = User.find_by(email: params[:email].to_s.downcase)
      if @user && @user.authenticate(params[:password])
        auth_token = JsonWebToken.encode({user_id: @user.id})
        # use the reverse of this statement to extract user_id from token
        render json: {access_token: auth_token}, status: :ok
        # render json: {user: @user}, status: :ok
      else
        render json: {error: 'Invalid username/password'}, status: :unauthorized
      end
    else
      render json: {error: 'User not found'}, status: :ok
    end
  end

  def confirm_email
    token = params[:token].to_s
    invitation = Invitation.find_by(token: token)
    if invitation && invitation.token_valid?
      invitation.mark_as_confirmed!
      # render json: {status: "Email confirmed...redirecting.."}, status: :ok
      redirect_to "https://macosa.herokuapp.com/invitation/"+invitation.token
    else
      render json: {status: "Invalid token or Token expired"}, status: :ok
    end
  end

  def show
    render json: {user: @user}, status: :ok
  end

  def add_admin
    # invoke function to set user as admin here.
  end

  # def invitation
  #   @owner = Owner.first
  #   if @current_user.email == @owner.email
  #   # @admin = current_user
  #     if Invitation.exists?(email: params[:email])
  #       render json: {duplicate: 'Invitation has been sent to this email already.'}, status: :ok
  #     else
  #       if @owner
  #         invitation = @owner.invitations.new(invitation_params)
  #         invitation.generate_invitation_instructions!
  #         if invitation.save
  #           @invitation = invitation
  #           #Invoke send invitation email function here
  #           if InvitationMailer.invite_email(@invitation).deliver_now
  #             render json: {status: 'Invitation sent successfully'}, status: :created
  #           else
  #             render json: {status: 'An error occured while trying to send invitation mail'}, status: :bad_request
  #           end
  #         else
  #           render json: {errors: invitation.errors.full_messages}, status: :bad_request
  #         end
  #       else
  #         render json: {error: @owner.errors.full_messages}, status: :ok
  #       end
  #     end
  #   else
  #     render json: {errors:'You are not authorized to perform this action.'}, status: :bad_request
  #   end
  # end


  def update
    @owner = Owner.first
    if @current_user.is_admin?
      if @user.email != @owner.email
        if @user.update(update_params)
          render json: {user: @user}
        else
          render json: {error: @user.errors}, status: :unprocessable_entity
        end
      elsif @user.email ==  @owner.email
        if !params[:is_admin]
          render json: {errors: "You cannot change privileges for the master account"}, status: :unauthorized
        elsif params[:is_admin]
          if @user.update(update_params)
            render json: {user: @user}
          else
            render json: {error: @user.errors}, status: :unprocessable_entity
          end
        end
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  # DELETE /types/2
  def destroy
    @owner = Owner.first
    if @user.email != @owner.email
      if @current_user.is_admin?
        @user.destroy
        render json: {user: @user}
      else
        render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
      end
    else
      render json: {error: "Master account cannot be deleted"}, status: :unauthorized
    end
  end




  private
    def set_user
      @user = User.find(params[:id])
    end


    def user_params
      params.require(:user).permit(:firstname, :lastname, :phone, :email, :password, :password_confirmation, :is_admin, :owner_id)
    end

    # def owner_update_params
    #   params.require(:user).permit(:firstname, :lastname, :phone, :email, :password, :password_confirmation, :owner_id)
    # end

    def update_params
      params.require(:user).permit(:firstname, :lastname, :phone, :email, :is_admin, :owner_id)
    end


end
