class Api::V1::OrdersController < Api::V1::BaseController
  before_action :set_order, only: [:show, :update] #, :destroy]
  before_action :authenticate_request!

  # before_action :set_user, only: [:create]
  # GET /orders
  def index
    if params.present?
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
    else
      @orders = Order.all
    end

    # @all_orders =
    @per_page = 10
    total_records = @orders.count
    @orders = Order.order(:created_at).page params[:page]
    # @all_orders = paginate @orders, per_page: 10
    # @orders = Order.all.paginate(per_page:=> 10)
    # @orders.paginate(page: 10)
    
    if (total_records % @per_page) == 0
      total_pages = total_records/@per_page
    else
      total_pages = (total_records/@per_page) + 1
    end

    @meta = { total_pages: total_pages, total_records: total_records }

    # paginate json: @orders, per_page: 10
    # render json: {, @orders}

    # complex = Complex.find(params[:id])
    # search_params = {complex_id: complex._id}
    # fields = Field.where(search_params)

    # render json: { complex: complex, fields: fields, search_params: search_params }, status: :ok

    render json: { meta: @meta, orders: @orders, each_serializer: OrderSerializer }, status: :ok

    # use a custom serializer to serialize this above:
    # paginate json: @orders, per_page: 10
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
    @order = Order.with_deleted.find(params[:id])
    if params[:type] == 'normal'
      @order.destroy
      render json: {success: "Order deleted and archived"}, status: :ok
    elsif params[:type] == 'forever'
      @order.really_destroy!
      render json: {success: "Order permanently deleted"}, status: :ok
    elsif params[:type] == 'undelete'
      @order.restore
      render json: {success: "Order restored"}, status: :ok
    end
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
