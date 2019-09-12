class Api::V1::TypesController < Api::V1::BaseController
  before_action :set_type, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # GET /types
  def index
    @types = Type.all
    render json: @types, status: :ok
  end

  # GET /types/1
  def show
    render json: @type, status: :ok
  end

  # POST /types
  def create
    if current_user.is_admin?
      @type = Type.new(type_params)

      if @type.save
        render json: @type, status: :created
      else
        render json: {errors: @type.errors}, status: :unprocessable_entity
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  # PATCH/PUT /types/1
  def update
    if current_user.is_admin?
      if @type.update(type_params)
        render json: @type, status: :ok
      else
        render json: {errors: @type.errors}, status: :unprocessable_entity
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end

  end

  # DELETE /types/1
  def destroy
    if current_user.is_admin?
      @type = Type.with_deleted.find(params[:id])
      if params[:type] == 'normal'
        @type.destroy
        render json: {success: "Type deleted and archived"}, status: :ok
      elsif params[:type] == 'forever'
        @type.really_destroy!
        render json: {success: "Type permanently deleted"}, status: :ok
      elsif params[:type] == 'undelete'
        @type.restore
        render json: {success: "Type restored"}, status: :ok
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @type = Type.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def type_params
      params.require(:type).permit(:name)
    end
end
