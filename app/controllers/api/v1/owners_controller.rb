class Api::V1::OwnersController < Api::V1::BaseController
  def index
    # change this action to return only first instance
    @owners = Owner.without_deleted.all
    if @owners.blank?
      render json: @owners, status: :ok
    else
      render json: @owners, status: :ok
    end
  end


   # POST /register
   def register
    @owner = Owner.first
    if @owner
      render json: {owner: @owner}, status: :ok
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
    end
  end




  private

    def user_params
      params.require(:owner).permit(:firstname, :lastname, :phone, :email, :password, :password_confirmation, :is_admin, :owner_id)
    end

    def owner_params
      # fix app still crashing on postman. append params .require(:modelName) if app crashes in
      # production
      params.require(:owner).permit(:email, :password, :name, :website)
    end
end
