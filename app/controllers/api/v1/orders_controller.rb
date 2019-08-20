class Api::V1::OrdersController < Api::V1::BaseController
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # before_action :set_user, only: [:create]
  # GET /orders
  def index
  # order_date, user_id, account_manager_id, customer_id,
  @orders = Order.where(nil)
  filtering_params(params).each do |key, value|
    @orders = @orders.public_send(key, value) if value.present?
  end



  # @orders = Order.filter(params.slice(:customer_id))



    # if params[:order_date] && params[:account_manager_id] && params[:customer_id]
    #   @orders = Order.where("order_date LIKE (%?%) AND account_manager_id LIKE (%?%) AND customer_id LIKE (%?%)", params[:order_date].to_date, params[:account_manager_id], params[:customer_id])
    # elsif params[:order_date]

    # else
    #   @orders = Order.all
    # end


    paginate json: @orders, per_page: 10


    # @orders = Order.all

    # render json: @orders
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    # todo: Assign create action to service worker due to cost of execution causing a timeout.
    # Also rewrite double validation method in the order model
    @order = @current_user.orders.create(order_params)
    # @user = User.find(params[:user_id])
    # @order = Order.new(order_params)
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_user
      @user = @current_user  
    end

    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:id, :order_no, :date, :description, :amount, :profit, :customer_id, :account_manager_id, :user_id, :currency_id, business_unit_orders_attributes: [ :id, :business_unit_id, :amount, :date, :order_id], manufacturer_orders_attributes: [:id, :manufacturer_id, :amount, :date, :order_id])
    end

    # A list of the param names that can be used for filtering the Order list
    def filtering_params(params)
      # sanitized_parameters = []
      # params.each do |param|
      allowed_keys = [:order_date, :user_id, :account_manager_id, :customer_id]
      allowed_keys.each do |key|
        if params.has_key?(key)
          return params.slice(key)
        end
      # params.slice(sanitized_parameters)
      end
    end
end
