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

      if params[:to].present? && params[:from].present?
        if params.has_key?(:page)
          @orders = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id)).interval(params[:to], params[:from]).page params[:page]
        else
          @orders = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id)).interval(params[:to], params[:from])
        end
        # @order_count = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id)).interval(params[:to], params[:from]).count
        @order_count = @orders.count
      else

        # Initialize order_count to later use it to paginate
        @order_count =  Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id, :currency_id)).count

        if params.has_key?(:page)
          # Only allow a trusted parameter "white list" through.
          @orders = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id, :currency_id)).order(created_at: :DESC).page params[:page]
        else
          @orders = Order.filter(params.slice(:customer_id, :order_date, :user_id, :account_manager_id, :currency_id)).order(created_at: :DESC)
        end

      end


      # Custom Pagination
      # @per_page = 10
      # if params.has_key?(:page)
      #   total_records = Order.count
      # else
      #   total_records = @orders.count
      # end


      # Reverse custom pagination code to testfix pagination bug
      # Special Custom Pagination for models with query params
      @per_page = 10
      if params.has_key?(:order_date) ||
        params.has_key?(:user_id) ||
        params.has_key?(:account_manager_id) ||
        params.has_key?(:customer_id) ||
        params.has_key?(:currency_id)

        total_records = @order_count
      else
        total_records = Order.count
      end

      # @orders = Order.all.page params[:page]

      if (total_records % @per_page) == 0
        total_pages = total_records/@per_page
      else
        total_pages = (total_records/@per_page) + 1
      end
      @meta = { total_pages: total_pages, total_records: total_records }
      # end


    else
      @orders = Order.all.order(created_at: :DESC)
      @per_page = 10
      total_records = Order.count
      if (total_records % @per_page) == 0
        total_pages = total_records/@per_page
      else
        total_pages = (total_records/@per_page) + 1
      end
      @meta = { total_pages: total_pages, total_records: total_records }
    end

    # # Custom Pagination
    #   @per_page = 10
    #   total_records = @orders.count
    #   @orders = Order.all.page params[:page]

    #   if (total_records % @per_page) == 0
    #     total_pages = total_records/@per_page
    #   else
    #     total_pages = (total_records/@per_page) + 1
    #   end
    #   @meta = { total_pages: total_pages, total_records: total_records }

      # Don't forget to set per_page in the model model:
        # per_page: 10

    # Finally, render pretty json lol
    render json: @orders, meta: @meta, status: :ok
  end


# end of index



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

  def current_user
    # @user_id = payload[0]['user_id']
    current_user = @current_user
  end

  # Trash Implementation

  def trash
    @order = Order.only_deleted.find(params[:id])
    if @order
      render json: @order, status: :ok
    else
      render json: {error: "Order not found or permanently deleted"}, status: :not_found
    end
  end

  def all_trash
    @orders = Order.only_deleted.all
    if @orders
      render json: @orders, status: :ok
    else
      render json: {error: "Order not found or permanently deleted"}, status: :unprocessable_entity
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
    # TO prevent SQL injection, Always sanitize parameters
    def filtering_params(params)
      params.slice(:order_date, :user_id, :account_manager_id, :customer_id, :currency_id)
    end
end
