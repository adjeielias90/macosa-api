class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show, :update]#, :destroy]
  # Authorize request before processing
  before_action :authenticate_request!, except: [:password_reset, :verify_reset_email, :verify_token, :password_update, :login, :confirm_email, :create]
  def index
    @users = User.all
    paginate json: @users, per_page: 10
    # render json: @users, status: :ok

    # @users = @pagy.paginate(page: params[:page], per_page: 2)
    # json_response(@users)
  end

  def create
    @owner = Owner.first
    #@admin = current_user
      if @owner
        if invitation = Invitation.find_by(email: params[:user][:email].to_s.downcase)
          if invitation.email_confirmed?
            if params[:user][:access_token].to_s.downcase == invitation.access_token.to_s.downcase
              @user = @owner.users.new(user_params)
              # user.generate_confirmation_instructions!
              if @user.save
                #Invoke email function here
                if invitation.is_admin == true
                  @user.set_as_admin!
                  invitation.destroy
                  render json: @user, status: :created
                else
                  invitation.destroy
                  render json: {error: "An error occured while deleting the invitation"}, status: :bad_request
                end
              else
                render json: {errors: @user.errors.full_messages}, status: :bad_request
              end
            else
              render json: {errors: "Invalid access token"}, status: :bad_request
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

    # @tenant = @owner.create_tenant(name: tenant_params[:company_name])
  end


  def login
    if @user = User.find_by(email: params[:email].to_s.downcase)
      if @user && @user.authenticate(params[:password])
        @auth_token = JsonWebToken.encode({user_id: @user.id})
        # use the reverse of this statement to extract user_id from token
        # render json: {[access_token: auth_token, user: @user]}, status: :ok
        # render json: {user: @user}, status: :ok
        # @user = [firstname: @user.firstname, lastname: @user.lastname, email: @user.email, is_admin: @user.is_admin, owner_id: @user.owner_id]
        render json: { access_token: [@auth_token, @user.id] }, status: :ok
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
      # redirect_to "https://macosa.herokuapp.com/"#invitation/"+invitation.token
      redirect_to "https://macosa.herokuapp.com/invitations/"+invitation.token
    else
      render json: {status: "Invalid token or Token expired"}, status: :ok
    end
  end

  def show
    render json: @user, status: :ok
  end

  def add_admin
    # invoke function to set user as admin here.
  end

  # def invitation
  #   @owner = Owner.first
  #   if current_user.email == @owner.email
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
    if current_user.is_admin?
      if @user.email != @owner.email
        if @user.update(update_params)
          render json: @user, status: :ok
        else
          render json: {error: @user.errors}, status: :unprocessable_entity
        end
      elsif @user.email ==  @owner.email
        if !params[:is_admin]
          render json: {errors: "You cannot change privileges for the master account"}, status: :unauthorized
        elsif params[:is_admin]
          if @user.update(update_params)
            render json: @user, status: :ok
          else
            render json: {error: @user.errors}, status: :unprocessable_entity
          end
        end
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  def password_reset
    # send password reset instructions with an email as a parameter
    # also generate reset token to handle authorization
    #post request
    #check if email exists
    user = User.find_by(email: params[:email].to_s.downcase)

    if !user
    #render error json if it doesnt
      render json: {error: 'No such account exists' }, status: :forbidden
    else
    #generate reset_token
      user.generate_reset_instructions!
    #send reset instructions if it does exist
      PasswordMailer.send_instructions(user).deliver_now
      render json: {success: 'Reset email with instructions sent.' }, status: :ok
    end
  end

  def password_update
    #updates users password after checking reset token
    #reset token not present or an invalid token triggers a 401
    @user = User.find_by(reset_token: params[:token].to_s) rescue nil
    if @user.present?
      if @user.reset_token_valid?
        if @user.update(password: params[:password])
          if @user.save!
            @user.mark_as_reset!
            render json: {success: "Reset Successful"}, status: :ok
          else
            render json: { errors: @user.errors }, status: 422
          end
        else
          render json: {error: "Unknown error occurred"}, status: 422
        end
      else
        render json: {error: "Token expired."}, status: :unauthorized
        # redirect_to "http://localhost:4200/password/forgot"
      end
    else
      # flash[:error] = "Sorry. User does not exist"
      render json: {error: 'User not found or An error occured.' }, status: :not_found
      # redirect_to "http://localhost:4200/password/forgot"
      # redirect_to "https://371fd396.ngrok.io/signup"
    end
  end

  def verify_reset_email
    # checks for the authenticity of the reset token
    user = User.find_by(reset_token: params[:token].to_s.downcase)
    if user && user.reset_token_valid?
      # auth_token = JsonWebToken.encode({subscriber_id: subscriber.id})
      # render json: {redirect: "redirecting to frontend with token..."}, status: :ok
      redirect_to "https://macosa.herokuapp.com/password/"+user.reset_token
    else
      redirect_to "https://macosa.herokuapp.com/login"
    end
  end

  def verify_token
    # checks for the authenticity of the reset token
    @user = User.find_by(reset_token: params[:token].to_s.downcase)

    if @user && @user.reset_token_valid?
      # auth_token = JsonWebToken.encode({subscriber_id: subscriber.id})
      render json: @user, status: :ok
    else
      render json: {error: 'Invalid or Expired token, redirecting to password reset...'}, status: :unauthorized
    end
  end

  # DELETE /types/2
  def destroy
    @owner = Owner.first
    if @user.email != @owner.email
      if current_user.is_admin?
        @user = User.with_deleted.find(params[:id])
        if params[:type] == 'normal'
          @user.destroy
          render json: {success: "User deleted and archived"}, status: :ok
        elsif params[:type] == 'forever'
          @user.really_destroy!
          render json: {success: "User permanently deleted"}, status: :ok
        elsif params[:type] == 'undelete'
          @user.restore
          render json: {success: "User restored"}, status: :ok
        end
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

    def password_params
    end

    # def owner_update_params
    #   params.require(:user).permit(:firstname, :lastname, :phone, :email, :password, :password_confirmation, :owner_id)
    # end

    def update_params
      params.require(:user).permit(:firstname, :lastname, :phone, :email, :is_admin, :owner_id)
    end





end
