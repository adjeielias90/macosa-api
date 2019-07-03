class Api::V1::UsersController < Api::V1::BaseController


  def create
    @owner = Owner.first

    if @owner
      user = @owner.users.new(user_params)

      if user.save
        #Invoke email function here
        render json: {status: 'User created successfully'}, status: :created
      else
        render json: {errors: user.errors.full_messages}, status: :bad_request
      end
    else
      render json: {error: @owner.errors.full_messages}
    end

    # @tenant = @owner.create_tenant(name: tenant_params[:company_name])

  end


  def login
    user = User.find_by(email: params[:email].to_s.downcase)

    if user && user.authenticate(params[:password])
      auth_token = JsonWebToken.encode({user_id: user.id})
      # use the reverse of this statement to extract user_id from token
      render json: {access_token: auth_token}, status: :ok
    else
      render json: {error: 'Invalid username/password'}, status: :unauthorized
    end
  end

  def confirm
  end



  private
    def user_params
      params.permit(:firstname, :lastname, :title, :phone, :email, :password, :password_confirmation, :is_admin, :owner_id)
    end


end
