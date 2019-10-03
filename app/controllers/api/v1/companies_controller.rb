class Api::V1::CompaniesController < Api::V1::BaseController
  before_action :set_company, only: [:show, :update] #, :destroy]
  before_action :authenticate_request!
  # Authorize request before processing
  before_action :authenticate_request!
  # GET /companies
  def index
    @companies = Company.all.order(created_at: :DESC).page params[:page]

    # Custom Pagination
    @per_page = 10
    total_records = @companies.count
    # @orders = Order.all.page params[:page]

    if (total_records % @per_page) == 0
      total_pages = total_records/@per_page
    else
      total_pages = (total_records/@per_page) + 1
    end
    @meta = { total_pages: total_pages, total_records: total_records }

    render json: @companies, meta: @meta, status: :ok
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
      @company = Company.with_deleted.find(params[:id])
      if params[:type] == 'normal'
        @company.destroy
        render json: {success: "Company deleted and archived"}, status: :ok
      elsif params[:type] == 'forever'
        @company.really_destroy!
        render json: {success: "Company permanently deleted"}, status: :ok
      elsif params[:type] == 'undelete'
        @company.restore
        render json: {success: "Company restored"}, status: :ok
      end
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
