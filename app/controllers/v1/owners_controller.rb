class V1::OwnersController < ApplicationController
  def index
    @owner = Owner.first
    if @owner.blank?
      render json: {status: "No owner found. Please create one."}, status: :unauthorized
    else
      render json: {status: 'Confirmed, owner exists'}, status: :ok
    end
  end


   # POST /register
   def register
    @owner = Owner.create(owner_params)
    if @owner.save
      response = { message: 'Owner account created successfully'}
      render json: response, status: :created
    else
      render json: @owner.errors, status: :bad
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
end
