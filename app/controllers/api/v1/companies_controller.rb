class Api::V1::CompaniesController < Api::V1::BaseController
  before_action :set_company, only: [:show, :update, :destroy]
  before_action :authenticate_request!
  # Authorize request before processing
  before_action :authenticate_request!
  # GET /companies
  def index
    @companies = Company.all
    render json:  @companies, status: :ok
  end

  # GET /companies/1
  def show
    render json: @company, status: :ok
  end

  # POST /companies
  def create
    if @current_user.is_admin?
      @owner = Owner.first
      @company = @owner.companies.new(company_params)

      if @company.save
        render json: @company, status: :created
      else
        render json: @company.errors, status: :unprocessable_entity
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @current_user.ia_admin?
      if @company.update(company_params)
        render json: @company
      else
        render json: @company.errors, status: :unprocessable_entity
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  # DELETE /companies/1
  def destroy
    if @current_user.is_admin
      @company.destroy, status: :ok
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit(:name, :phone, :email, :website, :address, :type_id, :background, :owner_id)
    end
end
