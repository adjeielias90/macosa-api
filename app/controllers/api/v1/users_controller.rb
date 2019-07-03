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




  private
    def user_params
      params.permit(:firstname, :lastname, :title, :phone, :email, :password, :password_confirmation, :is_admin, :owner_id)
    end


end
