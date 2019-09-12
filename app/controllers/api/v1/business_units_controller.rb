class Api::V1::BusinessUnitsController < Api::V1::BaseController
  before_action :set_business_unit, only: [:show, :update, :destroy]
  before_action :authenticate_request!
  # GET /business_units
  def index
    @business_units = BusinessUnit.all

    render json: @business_units
  end

  # GET /business_units/1
  def show
    render json: @business_unit
  end

  # POST /business_units
  def create
    @business_unit = BusinessUnit.new(business_unit_params)

    if @business_unit.save
      render json: @business_unit, status: :created
    else
      render json: @business_unit.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /business_units/1
  def update
    if @business_unit.update(business_unit_params)
      render json: @business_unit
    else
      render json: @business_unit.errors, status: :unprocessable_entity
    end
  end

  # DELETE /business_units/1
  def destroy
    @business_unit = BusinessUnit.with_deleted.find(params[:id])
    if params[:type] == 'normal'
      @business_unit.destroy
      render json: {success: "Business Unit deleted and archived"}, status: :ok
    elsif params[:type] == 'forever'
      @business_unit.really_destroy!
      render json: {success: "Business Unit permanently deleted"}, status: :ok
    elsif params[:type] == 'undelete'
      @business_unit.restore
      render json: {success: "Business Unit restored"}, status: :ok
    end

    @business_unit.destroy
      render json: {success: "Business unit deleted"}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business_unit
      @business_unit = BusinessUnit.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def business_unit_params
      params.require(:business_unit).permit(:name)
    end
end
