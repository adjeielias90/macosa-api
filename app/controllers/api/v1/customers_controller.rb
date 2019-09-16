class Api::V1::CustomersController < Api::V1::BaseController
  before_action :set_customer, only: [:show, :update]#, :destroy]
  before_action :authenticate_request!
  # GET /customers
  def index
    @customers = Customer.all

    render json: @customers
  end

  # GET /customers/1
  def show
    render json: @customer
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      render json: @customer, status: :created
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customers/1
  def update
    if @customer.update(customer_params)
      render json: @customer
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customers/1
  def destroy
    @customer = Customer.with_deleted.find(params[:id])
    if params[:type] == 'normal'
      @customer.destroy
      render json: {success: "Customer deleted and archived"}, status: :ok
    elsif params[:type] == 'forever'
      @customer.really_destroy!
      render json: {success: "Customer permanently deleted"}, status: :ok
    elsif params[:type] == 'undelete'
      @customer.restore
      render json: {success: "Customer restored"}, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customer_params
      params.require(:customer).permit(:name, :industry_id)
    end
end
