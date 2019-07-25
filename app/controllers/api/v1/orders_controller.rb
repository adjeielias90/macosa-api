class Api::V1::OrdersController < Api::V1::BaseController
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :authenticate_request!
  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    @order = @current_user.orders.new(order_params)
    @order.set_date!
    @order.generate_order_number!
    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:order_no, :date, :description, :amount, :profit, :customer_id, :account_manager_id, :user_id business_unit_orders_attributes: [ :id, :business_unit_id, :amount, :date, :order_id], manufacturer_orders_attributes: [:id, :manufacturer_id, :amount, :date, :order_id])
    end
end
