class Api::V1::OwnersController < ApplicationController
  def index
    @owner = Owner.first
    if @owner.blank?
      render json: {status: "No Macosa account found. Please create one."}, status: :unauthorized
    else
      render json: {status: 'Confirmed, Macosa account exists'}, status: :ok
    end
  end


   # POST /register
   def register
    @owner = Owner.first

    if @owner
      render json: {status: "Macosa already created, please login or reset."}, status: :unauthorized
    else
      @owner = Owner.create(owner_params)
      if @owner.save
        response = { message: 'Macosa created successfully'}
        render json: response, status: :created
      else
        render json: @owner.errors, status: :bad
      end
    end
  end




  private

  def owner_params
    params.permit(
      :email,
      :password
      # :company_id --add company_id after defining the other half of the relationship
    )
  end

  # def user_params
  #   params.require(:owner).permit(:firstname, :lastname, :title, :company_id, :phone, :email, :background, :admin)
  # end

  # def user_params
  # end
end
