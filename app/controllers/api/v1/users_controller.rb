class Api::V1::UsersController < ApplicationController
  def create
    @owner = Owner.first

    if @owner
      user = User.new(user_params)

      if user.save
        #Invoke email function here
        render json: {status: 'User created successfully'}, status: :created
      else
        render json: {errors: user.errors.full_messages}, status: :bad_request
      end
    else
      owner = Owner.new(owner_params)
      company = owner.create_company()
      user = User.new(user_params)


      if user.save && owner.save
        render json: {status: 'Macosa account created along with admin account. Please login.'}, status: :created
      else
        render json: {status: errors.full_messages}, status: :bad_request
      end
    end

  end


  private
    def user_params
      params.permit(:firstname, :lastname, :title, :company_id, :phone, :email, :password, :password_confirmation, :background, :is_admin)
    end

    def owner_params
      params.permit(:email, :password)
    end
end
