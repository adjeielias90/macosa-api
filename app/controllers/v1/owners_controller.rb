class V1::OwnersController < ApplicationController
  def index
    @owner = Owner.first
    if @owner.blank?
      render json: {status: "No master administrator found."}, status: :unauthorized
    else
      render json: {status: 'Confirmed, owner exists'}, status: :ok
    end
  end
end
