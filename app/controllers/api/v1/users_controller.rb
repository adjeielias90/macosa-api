class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render json: {status: 'User created successfully'}, status: :created
    else
      render json: {errors: user.error.full_messages}, status: :bad_request
  end


  private
    def user_params
      params.require(:user).permit(:firstname, :lastname, :title, :company_id, :phone, :email, :background, :is_admin)
    end
end
