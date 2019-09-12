class Api::V1::ManufacturersController < Api::V1::BaseController
  before_action :set_manufacturer, only: [:show, :update, :destroy]
  before_action :authenticate_request!
  # GET /manufacturers
  def index
    @manufacturers = Manufacturer.all

    render json: @manufacturers
  end

  # GET /manufacturers/1
  def show
    render json: @manufacturer
  end

  # POST /manufacturers
  def create
    @manufacturer = Manufacturer.new(manufacturer_params)

    if @manufacturer.save
      render json: @manufacturer, status: :created
    else
      render json: @manufacturer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /manufacturers/1
  def update
    if @manufacturer.update(manufacturer_params)
      render json: @manufacturer
    else
      render json: @manufacturer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /manufacturers/1
  def destroy
    @manufacturer = Manufacturer.with_deleted.find(params[:id])
    if params[:type] == 'normal'
      @manufacturer.destroy
      render json: {success: "Manufacturer deleted and archived"}, status: :ok
    elsif params[:type] == 'forever'
      @manufacturer.really_destroy!
      render json: {success: "Manufacturer permanently deleted"}, status: :ok
    elsif params[:type] == 'undelete'
      @manufacturer.restore
      render json: {success: "Manufacturer restored"}, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manufacturer
      @manufacturer = Manufacturer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def manufacturer_params
      params.require(:manufacturer).permit(:name)
    end
end
