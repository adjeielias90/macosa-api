class Api::V1::IndustriesController < Api::V1::BaseController
  before_action :set_industry, only: [:show, :update]#, :destroy]
  before_action :authenticate_request!
  # GET /industries
  def index
    @industries = Industry.all

    render json: @industries
  end

  # GET /industries/1
  def show
    render json: @industry
  end

  # POST /industries
  def create
    @industry = Industry.new(industry_params)

    if @industry.save
      render json: @industry, status: :created
    else
      render json: @industry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /industries/1
  def update
    if @industry.update(industry_params)
      render json: @industry
    else
      render json: @industry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /industries/1
  def destroy
    @industry = Industry.with_deleted.find(params[:id])
    if params[:type] == 'normal'
      @industry.destroy
      render json: {success: "Industry deleted and archived"}, status: :ok
    elsif params[:type] == 'forever'
      @industry.really_destroy!
      render json: {success: "Industry permanently deleted"}, status: :ok
    elsif params[:type] == 'undelete'
      @industry.restore
      render json: {success: "Industry restored"}, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industry
      @industry = Industry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def industry_params
      params.require(:industry).permit(:name)
    end
end
