class Api::V1::OrdersController < Api::V1::BaseController
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # before_action :set_user, only: [:create]
  # GET /orders
  def index
    # Test condition here to find interval scope
      # if 'to' and 'from' present,
      # Call the interval scope with:
      # Order.interval('from_datetime_obj: 2015-07-09', 'to_datetime_obj: 2015-07-09')
    #
    # if params[:to].present? && params[:from].present?
      # @orders = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id)).interval(params[:to], params[:from])
    # else
      @orders = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id, :currency_id))
    # end
    paginate json: @orders, per_page: 10
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    @order = @current_user.orders.create(order_params)
    # @order.set_date!
    if @order.save
      @order.generate_order_number!
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
    render json: @order
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = @current_user
    end

    def set_order
      @order = Order.find(params[:id])
    end

    # Merge pretty params

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:id, :order_no, :date, :description, :amount, :profit, :customer_id, :account_manager_id, :user_id, :currency_id, business_unit_orders_attributes: [ :id, :business_unit_id, :amount, :date, :order_id], manufacturer_orders_attributes: [:id, :manufacturer_id, :amount, :date, :order_id])
    end

    # A list of the param names that can be used for filtering the Order list
    def filtering_params(params)
      params.slice(:order_date, :user_id, :account_manager_id, :customer_id, :currency_id)
    end
end
