class Api::V1::OwnersController < Api::V1::BaseController
  def index
    @owner = Owner.first
    render json: @owner, status: :ok
  end


   # POST /register
   def register
    # @owner = Owner.first

    # if @owner
    #   render json: {status: "Macosa already created, please login or reset."}, status: :unauthorized
    # else
    #   @owner = Owner.create(owner_params)
    #   # Invoke send mail method here.

    #   if @owner.save
    #     response = { message: 'Macosa created successfully'}
    #     render json: response, status: :created
    #   else
    #     render json: @owner.errors, status: :bad
    #   end
    # end
    @owner = Owner.first

    if @owner
      render json: {owner: @owner}, status: :ok
      # @user = @owner.users.new(user_params)
      # puts (user_params)
      # if @user.save
      #   #Invoke email function here
      #   render json: {data: @user}, status: :created
      # else
      #   render json: {errors: @user.errors.full_messages}, status: :bad_request
      # end
    else
      @owner = Owner.new(owner_params)

      if @owner.save

        @user = @owner.users.new(user_params)


        if @user.save
          @user.set_as_admin!
          render json: {owner: @user}, status: :created
          # 'Macosa account created along with admin account. Please login.'
        else
          render json: {data: @user.errors.full_messages}, status: :bad_request
        end

      else
        render json: {error: @owner.errors.full_messages}
      end

      # @tenant = @owner.create_tenant(name: tenant_params[:company_name])

    end

  end




  private

    def user_params
      params.permit(:firstname, :lastname, :phone, :email, :password, :password_confirmation, :is_admin, :owner_id)
    end

    def owner_params
      # fix app still crashing on postman. append params .require(:modelName) if app crashes in
      # production
      params.permit(:email, :password, :name, :website)
    end
end
