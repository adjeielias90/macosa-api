class Api::V1::CompanyTypesController < Api::V1::BaseController
  before_action :set_company_type, only: [:show, :update, :destroy]

  # GET /companies
  def index
    @company_types = CompanyType.all
    render json: @company_types, status: :ok
  end

  # GET /companies/1
  def show
    render json: @company_type
  end

  # POST /companies
  def create
    if CompanyType.find_by(typename: company_type_params[:typename])
      render json: {duplicate: "Company type already exists"}, status: :unprocessable_entity
    else
      @company_type = CompanyType.new(company_type_params)

      if @company_type.save
        render json: @company_type, status: :created
      else
        render json: @company_type.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company_type.update(companytype_params)
      render json: @company_type
    else
      render json: @company_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company_type.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_type
      @company_type= company_type.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_type_params
      params.require(:company_type).permit(:typename)
    end
end
